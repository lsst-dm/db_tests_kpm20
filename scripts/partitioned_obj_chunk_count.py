import collections
import glob
import os.path
import sys

# This script will browse files in the following path:
#  partitioned/<in-chunk>/Object/chunk_*.txt
# run it like:
#    Python script.py partitioned/


def find_chunks (dir_path):
    chunks = {}
    for dir_chunk_path in glob.glob(dir_path + "/*"):
        for file_path in glob.glob(dir_chunk_path + "/Object/chunk_*.txt"):
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

 

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("usage: <firstWorkerNum> <lastWorkerNum> <directory>")
        print(sys.argv)
        sys.exit(1)

    firstWorker = int(sys.argv[1])
    lastWorker = int(sys.argv[2])
    dir_path = sys.argv[3]

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

    
