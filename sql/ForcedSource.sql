CREATE TABLE `ForcedSource` (
  `deepSourceId` bigint(20) NOT NULL,
  `scienceCcdExposureId` bigint(20) NOT NULL,
  `psfFlux` float DEFAULT NULL,
  `psfFluxSigma` float DEFAULT NULL,
  `flagBadMeasCentroid` bit(1) NOT NULL,
  `flagPixEdge` bit(1) NOT NULL,
  `flagPixInterpAny` bit(1) NOT NULL,
  `flagPixInterpCen` bit(1) NOT NULL,
  `flagPixSaturAny` bit(1) NOT NULL,
  `flagPixSaturCen` bit(1) NOT NULL,
  `flagBadPsfFlux` bit(1) NOT NULL,
  `chunkId` int(11) NOT NULL,
  `subChunkId` int(11) NOT NULL,
  PRIMARY KEY (`deepSourceId`,`scienceCcdExposureId`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
