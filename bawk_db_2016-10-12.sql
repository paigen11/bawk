# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.15)
# Database: bawk_db
# Generation Time: 2016-10-12 20:15:18 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table bawks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bawks`;

CREATE TABLE `bawks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `total_votes` int(11) DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `location` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `bawks` WRITE;
/*!40000 ALTER TABLE `bawks` DISABLE KEYS */;

INSERT INTO `bawks` (`id`, `user_id`, `avatar`, `content`, `total_votes`, `time`, `location`, `username`)
VALUES
	(1,2,NULL,'I want to go to Hong Kong!',3,'2016-10-04 11:22:28',NULL,NULL),
	(2,3,NULL,'Southeast Asia - Vietnam, Cambodia and Japan are at the top of my list',7,'2016-10-04 11:22:28',NULL,NULL),
	(3,4,NULL,'Typically, I do not like flying, but I would go to Hawaii.',9,'2016-10-04 11:22:28',NULL,NULL),
	(4,5,NULL,'The Bahamas are a lot of fun to visit.',5,'2016-10-04 11:22:28',NULL,NULL),
	(5,5,NULL,'If you have not seen the Grand Caymans, they are worth a trip.',6,'2016-10-04 11:22:28',NULL,NULL),
	(6,2,NULL,'Germany was also really fun to visit.',4,'2016-10-04 11:22:28',NULL,NULL),
	(7,2,NULL,'My husband is from Trinidad, that\'s a great country.',3,'2016-10-04 11:22:28',NULL,NULL),
	(13,13,NULL,'Los Angeles will always have my heart. I lived there for ages.',4,'2016-10-04 11:34:29',NULL,NULL),
	(14,14,NULL,'I love rock climbing, so most of Arizona is on my list to see.',4,'2016-10-04 11:38:18',NULL,NULL),
	(15,16,NULL,'My wife is from the northeast, so we go back at least once a year to see her family. It is nice in the summer.',3,'2016-10-04 11:48:05',NULL,NULL),
	(18,9,NULL,'Germany, Austria and Switzerland are my jam.',2,'2016-10-06 16:13:01',NULL,NULL),
	(19,9,NULL,'I have always wanted to ski the Swiss Alps.',2,'2016-10-06 16:13:17',NULL,NULL),
	(20,2,NULL,'I did not care so much for San Diego, I am sorry to say.',-1,'2016-10-06 16:13:45',NULL,NULL),
	(22,10,NULL,'I want to go to Italy.',0,'2016-10-07 10:02:41',NULL,NULL),
	(23,10,NULL,'New Orleans is always a fun time.',0,'2016-10-07 10:04:19',NULL,NULL),
	(24,11,NULL,'New Zealand it is. Big fan of Lord of the Rings right here.',1,'2016-10-07 10:05:58',NULL,NULL),
	(25,15,NULL,'I grew up in Connecticut, so I love going back there.',1,'2016-10-07 10:13:49',NULL,NULL),
	(26,12,NULL,'I got remarried in the Bahamas with my family there. That was special!',1,'2016-10-07 10:23:14',NULL,NULL),
	(41,17,NULL,'I went to India recently, it was cool, but I will not be going back anytime soon.',0,'2016-10-07 13:05:26',NULL,NULL),
	(43,10,NULL,'I would also really like to see Australia at least once.',1,'2016-10-07 16:13:02',NULL,NULL),
	(45,2,NULL,'We got married in the Dominican Republic, that was lovely.',3,'2016-10-10 09:26:05',NULL,NULL);

/*!40000 ALTER TABLE `bawks` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table follow
# ------------------------------------------------------------

DROP TABLE IF EXISTS `follow`;

CREATE TABLE `follow` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `follower_id` int(11) DEFAULT NULL,
  `following_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `follow` WRITE;
/*!40000 ALTER TABLE `follow` DISABLE KEYS */;

INSERT INTO `follow` (`id`, `follower_id`, `following_id`)
VALUES
	(1,2,4),
	(2,2,3),
	(3,2,5),
	(4,2,9),
	(5,2,10),
	(6,2,11),
	(7,2,12),
	(8,2,13),
	(9,2,14),
	(10,2,15),
	(11,2,16),
	(12,2,17),
	(13,2,3),
	(14,2,4),
	(15,2,5),
	(16,2,9),
	(17,2,10),
	(18,2,11),
	(19,2,12),
	(20,2,3),
	(21,2,4),
	(22,14,3),
	(23,14,2),
	(24,14,4),
	(25,10,3),
	(26,10,4),
	(27,10,2),
	(28,10,9),
	(29,10,11),
	(30,10,14),
	(31,13,4),
	(32,13,3),
	(33,13,5),
	(34,13,4),
	(35,13,3),
	(36,13,9),
	(37,15,4),
	(38,15,3),
	(39,15,5),
	(40,15,9),
	(41,15,10),
	(42,15,11),
	(43,15,12),
	(44,15,4),
	(45,15,3),
	(46,15,9),
	(47,15,10),
	(48,15,11),
	(49,15,12),
	(50,15,4),
	(51,15,3),
	(52,15,5),
	(53,15,9),
	(54,15,10),
	(55,15,3),
	(56,15,4),
	(57,15,5),
	(58,15,9),
	(59,15,10),
	(60,15,11),
	(61,15,12),
	(62,15,13),
	(63,15,14),
	(64,15,16),
	(65,15,17),
	(66,15,2),
	(67,16,4),
	(68,16,3),
	(69,16,5),
	(70,16,9),
	(71,16,10),
	(72,16,11),
	(73,16,12),
	(74,16,2),
	(75,9,4),
	(76,9,5),
	(77,9,10),
	(78,9,11),
	(79,9,12),
	(80,9,13),
	(81,9,14),
	(82,9,15),
	(83,9,16),
	(84,9,17),
	(85,9,3),
	(86,10,3),
	(87,2,5),
	(88,2,5),
	(89,2,9),
	(90,2,10),
	(91,2,11),
	(92,2,12),
	(93,2,13),
	(94,2,14),
	(95,2,15),
	(96,2,16),
	(97,2,17),
	(98,2,4),
	(99,2,3),
	(100,2,5),
	(101,2,9),
	(102,2,10),
	(103,2,4),
	(104,2,11),
	(105,2,12),
	(106,2,13),
	(107,2,14),
	(108,2,15),
	(109,2,16),
	(110,2,17),
	(111,2,3),
	(112,10,13),
	(113,10,15),
	(114,10,16),
	(115,10,17),
	(116,10,12),
	(117,10,5),
	(118,17,4),
	(119,17,5),
	(120,17,2),
	(121,17,10),
	(122,17,11),
	(123,17,9),
	(124,3,2),
	(125,3,4);

/*!40000 ALTER TABLE `follow` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;

INSERT INTO `user` (`id`, `username`, `password`, `email`, `avatar`)
VALUES
	(2,'Paige','$2b$12$2WsEKOu6d8xrIdEC1cHvtetZszB1bNzh86DLJUiJcdqFVC4dq.FQG','paige@mail.com','https://s-media-cache-ak0.pinimg.com/564x/29/fa/14/29fa1441f2a0446e9aa45cee74495a83.jpg'),
	(3,'Sean','$2b$12$SQhK4iMxhwDogv2cszxPCO7SkBzeMR1wWCl6pCAj5LwoFlFfTKDki','joe@joe.com','http://cdn3-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-15.jpg'),
	(4,'Nancy','$2b$12$CeZmszn7iIkLYUHXPKXE.eg7SzYvvM/pi6NgfVudbUcI1tlLj/Tpq','peggy@mail.com','https://s-media-cache-ak0.pinimg.com/736x/ca/32/44/ca3244addedf3b1e9fd0d90629bc339e.jpg'),
	(5,'Robert','$2b$12$Ie60Sc6uyDX4GCK1VGTpJOtTPu/pO1hfQRnFs83WN0bpY4uElLqzu','joebob@gmail.com','http://rlv.zcache.com/beagle_puppy_square_sticker-r9532c0a19c554d7bba24b48ff6ca2434_v9i40_8byvr_324.jpg'),
	(9,'George','$2b$12$BQNYm89sSnn1PwMEQupfm.AFv5DqqMvZ0syZtczVqe83EOLT.obIa','george@gmail.com','https://s-media-cache-ak0.pinimg.com/236x/13/66/be/1366be14db0cd16ab043bb46ea5bc0af.jpg'),
	(10,'Cindy','$2b$12$d05BZq4v.uUd4Hc7Nab1C.m4wiYSsmRl.9bFWelEKLrtNXzrgcNYG','cindy@gmail.com','http://how-to-train-puppies.com/images/how-to-train-a-scottish-terrier.jpg'),
	(11,'Teddy','$2b$12$Py0osVSypuhiKN9sQq7Oc.J1/HZRsIsHhgzJfu0n2kurNgCePb2pC','test@test.test','https://s-media-cache-ak0.pinimg.com/236x/8a/e3/05/8ae305691bf8db89a54b8b2661738689.jpg'),
	(12,'Meg','$2b$12$d05BZq4v.uUd4Hc7Nab1C.m4wiYSsmRl.9bFWelEKLrtNXzrgcNYG','cindy@gmail.com','https://s-media-cache-ak0.pinimg.com/originals/14/5f/7a/145f7a8b5f1e31c7fbc31a37eebe2a32.jpg'),
	(13,'Lucie','$2b$12$swmUjk3iiQV2geHDceANsusvT3pMdab1tG3TvVQngBE0iOamY0K1.','kitten@mail.com','https://ae01.alicdn.com/kf/HTB1d6czNpXXXXcUaXXXq6xXFXXXH/2016-New-Fashion-Good-Quality-Square-45x45cm-Pillowcase-Lovely-Cute-Animal-font-b-Papillon-b-font.jpg'),
	(14,'Flynn','$2b$12$1247tuVgy0DFUrPiHgIQhuuDn6fnDaJZDbCWSvBcEKuVDuz/anct6','kitten2@gmail.com','https://i.ytimg.com/vi/a6KGPBflhiM/hqdefault.jpg'),
	(15,'Bruce','$2b$12$Ma6Tu0QDirX.Q26/xUwVaepJ4BP.ANOJdEfEfmSdq.j8BVEniruXa','12345@mail.com','http://rlv.zcache.co.nz/fox_red_labrador_puppy_square_sticker-r95d2c19fa8254d9b8ca728f6c4578dcd_v9i40_8byvr_324.jpg'),
	(16,'Dean','$2b$12$Ydrp.WTu5Sdts88GMtxhoelYeuBA2RHH/pd6KgkjBs/UggTZbEpYS','123456@mail.com','https://s-media-cache-ak0.pinimg.com/564x/bf/1c/d1/bf1cd16ebeed04668dbb7c4d627e0548.jpg'),
	(17,'Larry','$2b$12$BvGAksDYlNFwv2jMHAfT9O0LFEQdYZ3eIAZXOSCW8qMroSoyhp8By','paige.niedringhaus@fortyfour.com','http://www.freehartsweimaraners.com/sitebuilder/images/Weimypup-257x274.jpg');

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table votes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `votes`;

CREATE TABLE `votes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `vote_type` int(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `votes` WRITE;
/*!40000 ALTER TABLE `votes` DISABLE KEYS */;

INSERT INTO `votes` (`id`, `pid`, `uid`, `vote_type`)
VALUES
	(1,13,2,1),
	(6,2,2,1),
	(7,3,2,1),
	(8,5,2,1),
	(9,4,2,1),
	(10,15,2,1),
	(11,14,2,1),
	(12,2,14,1),
	(13,13,14,1),
	(14,8,14,1),
	(15,6,14,1),
	(16,12,14,-1),
	(17,16,14,1),
	(18,3,14,1),
	(19,8,10,1),
	(20,16,10,1),
	(21,6,10,1),
	(22,12,10,1),
	(23,10,10,1),
	(24,9,10,1),
	(25,11,10,1),
	(26,3,10,1),
	(27,17,10,1),
	(28,1,10,1),
	(29,2,10,1),
	(30,14,10,1),
	(31,7,10,1),
	(32,3,13,1),
	(33,2,13,1),
	(34,5,13,1),
	(35,4,13,1),
	(36,3,15,1),
	(37,2,15,1),
	(38,5,15,1),
	(39,4,15,1),
	(40,17,15,1),
	(41,16,15,1),
	(42,8,15,1),
	(43,6,15,1),
	(44,12,15,1),
	(45,11,15,1),
	(46,10,15,1),
	(47,9,15,1),
	(48,1,15,1),
	(49,7,15,1),
	(50,13,15,1),
	(51,14,15,1),
	(52,15,15,1),
	(53,17,16,1),
	(54,16,16,1),
	(55,8,16,1),
	(56,12,16,1),
	(57,11,16,1),
	(58,10,16,1),
	(59,9,16,1),
	(60,1,16,1),
	(61,7,16,1),
	(62,3,16,1),
	(63,4,16,1),
	(64,5,16,1),
	(65,2,16,1),
	(66,6,16,1),
	(67,13,9,1),
	(68,3,9,1),
	(69,2,9,1),
	(70,5,9,1),
	(71,4,9,1),
	(72,15,9,1),
	(73,14,9,1),
	(74,21,10,1),
	(75,20,10,-1),
	(76,27,2,1),
	(77,19,2,1),
	(78,18,2,1),
	(79,25,2,1),
	(80,26,2,1),
	(81,24,2,1),
	(82,21,2,1),
	(83,43,10,1),
	(84,18,10,1),
	(85,42,10,1),
	(86,45,2,1),
	(87,3,17,1),
	(88,5,17,1),
	(89,19,17,1),
	(90,45,17,1),
	(91,45,3,1),
	(92,3,3,1),
	(93,44,3,1),
	(94,42,3,1),
	(95,40,3,1),
	(96,39,3,1),
	(97,38,3,1),
	(98,37,3,1),
	(99,35,3,1),
	(100,36,3,1),
	(101,34,3,1),
	(102,33,3,-1);

/*!40000 ALTER TABLE `votes` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
