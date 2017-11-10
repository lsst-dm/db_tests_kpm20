import collections
import glob
import os.path
import shutil
import socket
import sys

# This script has 2 modes.
# - The first is to examine a directory and find all the files that match:
#     chunk_*.txt or chunk_*_overlap.txt where * is a chunk number.
#  - It collects all the chunk numbers and splits them evenly across a contingous
#     series of workers. It writes these to files in the original directory that
#     match the workers' names, such as ccqserv101.
#  - ex: python partitioned_obj_chunk_count.py count 101 124 ~/partitioned
#     count files in ~/partitoned and split found chunks across
#     workers ccqserv101 to ccqserv124 inclusive.
# - The second mode is collection all the files for a chunk on the local node.
#   This MUST be started on EACH node where the data is to be collected.
#  - It opens the file in the source directory with the matching host name
#    created by the first mode. It then hunts for the files that are in the file
#    and copies them to the destination directory.
#  - ex: python test.py collect ~/partitioned ~/loading
#    NOTE: ~/partitioned is likely mapped to shared storage and ~/loading is
#      probably local, so this gives the loader local files to work with.


def find_chunks (dir_path, table):
    chunks = {}
    # This is related to code in collectChunks(), check if changes are made.
    chunkGlob = "/" + table + "/chunk_*.txt"
    print (dir_path, table, chunkGlob)
    for dir_chunk_path in glob.glob(dir_path + "/*"):
        for file_path in glob.glob(dir_chunk_path + chunkGlob):
            file_name        = os.path.basename(file_path)
            file_name_no_ext = os.path.splitext(file_name)[0]

            chunk = None

            if  file_name_no_ext.startswith("chunk_"):
                if file_name_no_ext.endswith("_overlap"):
                    chunk = int(file_name_no_ext[len("chunk_"):-len("_overlap")])
                else:
                    chunk = int(file_name_no_ext[len("chunk_"):])
            if chunk is not None:
                if chunk not in chunks:
                    chunks[chunk] = True

    return chunks


def countChunks(firstWorker, lastWorker, dir_path):
    chunks = find_chunks(dir_path)
    for chunk in chunks:
        print(chunk)

    workerChunks = collections.defaultdict(list)
    worker = firstWorker
    for chunk in chunks:
        workerChunks[worker].append(chunk)
        sys.stdout.write('.')
        sys.stdout.flush()
        worker += 1
        if worker > lastWorker:
            worker = firstWorker
    print()

    for w in range(firstWorker, lastWorker+1):
        fName = os.path.join(dir_path, "ccqserv" + str(w))
        f = open(fName, 'w')
        wchunks = workerChunks[w]
        for wchunk in wchunks:
            f.write(str(wchunk) + '\n')
        f.close()
        # check the file
        f2 = open(fName, 'r')
        j = 0
        for line in f2:
            j += 1
        print(w, fName, j, len(workerChunks[w]))
        f2.close()



def collectChunks(dir_path, destDir, table):
    '''Open the file with our host's name.
    Collect the list of chunk numbers in the file.
    Go through the directory and copy every file for those chunks
    to this computer.'''
    hName = socket.gethostname()
    print(hName)
    fName = os.path.join(dir_path, hName)
    print fName
    print table
    f = open(fName, 'r')
    targets = {}
    for line in f:
        chunkId = int(line)
        print(chunkId)
        targets[chunkId] = 0
    f.close()

    if not os.path.exists(destDir):
        os.makedirs(destDir)

    #Find every chunk file that includes one of those numbers and copy it
    hits = 0
    total = 0
    # This is related to code in find_chunks(), check if changes are made.
    chunkGlob = "/" + table + "/chunk_*.txt"
    for dir_chunk_path in glob.glob(dir_path + "/*"):
        for file_path in glob.glob(dir_chunk_path + chunkGlob):
            total += 1
            file_name        = os.path.basename(file_path)
            file_name_no_ext = os.path.splitext(file_name)[0]

            chunk = None

            if  file_name_no_ext.startswith("chunk_"):
                if file_name_no_ext.endswith("_overlap"):
                    chunk = int(file_name_no_ext[len("chunk_"):-len("_overlap")])
                else:
                    chunk = int(file_name_no_ext[len("chunk_"):])
            if chunk is not None and chunk in targets:
                hits += 1
                print("Hit:", hits, file_path)
                newName = os.path.basename(dir_chunk_path)
                newName += "_" + file_name
                print(newName)
                newName = os.path.join(destDir, newName)
                print(newName)
                shutil.copyfile(file_path, newName)
    print("Hits=", hits, "totalChecked=", total)



if __name__ == "__main__":
    la = len(sys.argv)
    a1 = sys.argv[1]
    if not ((la == 5 and a1 == "collect") or (la == 6 and a1 == "count")):
        print("usage: count <firstWorkerNum> <lastWorkerNum> <directory> <table>")
        print("usage: collect <sourceDirectory> <destinationDirectory> <table>")
        print(sys.argv)
        sys.exit(1)

    if a1 == "count":
        firstWorker = int(sys.argv[2])
        lastWorker = int(sys.argv[3])
        dir_path = sys.argv[4]
        table = sys.argv[5]
        countChunks(firstWorker, lastWorker, dir_path, table)
    elif a1 == "collect":
        dir_path = sys.argv[2]
        destDir = sys.argv[3]
        table = sys.argv[4]
        collectChunks(dir_path, destDir, table)


