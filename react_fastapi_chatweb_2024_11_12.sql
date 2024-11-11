# ************************************************************
# Sequel Ace SQL dump
# Version 20075
#
# https://sequel-ace.com/
# https://github.com/Sequel-Ace/Sequel-Ace
#
# Host: localhost (MySQL 8.0.32)
# Database: react_fastapi_chatweb
# Generation Time: 2024-11-11 17:48:01 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table group_memberships
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_memberships`;

CREATE TABLE `group_memberships` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `group_id` int DEFAULT NULL,
  `joined_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_group_memberships_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `group_memberships` WRITE;
/*!40000 ALTER TABLE `group_memberships` DISABLE KEYS */;

INSERT INTO `group_memberships` (`id`, `user_id`, `group_id`, `joined_at`)
VALUES
	(1,1,1,'2024-11-11 12:45:16'),
	(2,2,1,'2024-11-11 12:45:16'),
	(3,3,1,'2024-11-11 12:45:16');

/*!40000 ALTER TABLE `group_memberships` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `public_key` text COLLATE utf8mb4_general_ci,
  `private_key` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;

INSERT INTO `groups` (`id`, `name`, `public_key`, `private_key`)
VALUES
	(1,'Fun Group','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvF9GuqhjCsiWB1cL2y21\nnvf53+iynkzQlyeNWXHq71tkG1XEzgIRIzITJdi12Fo48dmU6+jqUfgnvjmbC1oJ\nR1aSVTgpz7QHcZ+ky2m7Ggq0BTGy6Mw97duf4saICM6s4r0nO+Ri/LuuLkw+rLmz\nxp4P7D2cMzmQrHQxxV0Olz14ebXjEZAosT2vmPEWFiMcuIn4xM60OoIhFtu0hByI\nXKUlhj6xnI90pvLsTuiaJmwY6Mb4PEgpfvtbUe5uj4expWRkuPORkVjgOaP6LC8U\njXP8QchbRglsGIkt7HOnRg1T+UWtmu+pV+lxpBv4qW/uTbQrbXFXcqQQEG1SFpJb\nUQIDAQAB\n-----END PUBLIC KEY-----\n','-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC8X0a6qGMKyJYH\nVwvbLbWe9/nf6LKeTNCXJ41ZcervW2QbVcTOAhEjMhMl2LXYWjjx2ZTr6OpR+Ce+\nOZsLWglHVpJVOCnPtAdxn6TLabsaCrQFMbLozD3t25/ixogIzqzivSc75GL8u64u\nTD6subPGng/sPZwzOZCsdDHFXQ6XPXh5teMRkCixPa+Y8RYWIxy4ifjEzrQ6giEW\n27SEHIhcpSWGPrGcj3Sm8uxO6JombBjoxvg8SCl++1tR7m6Ph7GlZGS485GRWOA5\no/osLxSNc/xByFtGCWwYiS3sc6dGDVP5Ra2a76lX6XGkG/ipb+5NtCttcVdypBAQ\nbVIWkltRAgMBAAECggEADZlWPpb18XsaI6UD2NqjrDqMOj8vF/EFNQhYsr6f3pBL\nOZL3ToUFLjSI/9g1ho0647DYyLArrGe9HMVFXWwuU81a6paPpCxDxk7nY3z6Ui64\nINDd8OL/zIposEMzYmljP0o3CSKbh9HXyQVdl/QfF6VlEmG/Q05yVJTd2/j0GvRo\nCHxDu3ZOWW+xsqdPVIDwU2/DcoOQpRZCe4hbu3l+HhMqdtnEWUeuX7fnYEpZ8Q34\ndwN00zT0xYyNlIOZLoPWrh30mEBQnilFAiiwmjnNADk2Pj3h9cb+0A860dbzPPEu\nB1TIoqeK0fT1VJiiYIdvOoshcSVCf9pTQ7UI3/SxjQKBgQDvoK7vpsmazGkOKS1h\ncijIMmnqjgfG3PN9riQYQ19P9DNZm8JGfe9mS3oMwOOAv02VPGF5vu+vHQBfbKEj\nIyYVfAuTJa4aUtV5eNIAzPQ40tQxsxCWxiL9OUAyINNelY1l4yYkbKMVMSaTeLlz\n+Z7zdkP0IcqXiVyKUlo5PyGjNQKBgQDJPhXcBDmH+CwFlfbrh62dIWlIrTFEvf80\n+L+ofYtzAO75Wj9tdQ/IDIpHCjoPCFpsu3vBQB7QMsDZ4o9PSTW0PftgKqTu+UK/\nDF8rThUzP3ZONJ7k1Y5XAemAoKm8M/lPYthtAd3Y78kdhwFzDVpObTRKtJjZeKmS\n6oWc5LhfLQKBgEncxK94QMJnaaaEyMk1sB5tc7pqBzmkF6XQzK1x7uotQrrHSS4D\nWYy1jSxrNHUWAqsSjpVBZo4aqWfAizbSecW7k7HKtozEpaqotEqs4ka1rdSX9nAT\nKOvW/tO0zJJmFMyoJLSri+VXXiWs27VE51ryRGX3GIR3QcAdPFRTAmJVAoGABqBi\nu+Hvuwhy+qQbg1nuX5QwEVKSor7W3nmqZfPsWZcYR2GvYP1PzbiL/RbbHo+Z2qa5\nxn1EBnsFWqdZLLUubYb09g+xaqUOi5fuslBZ5lwamyykZsiZbUgE1lV0AVx8wx5w\nHfbHxVLv/mbpp04zQQ3bgPI9bjvI6auLRsVJROkCgYBxkYMjHJmCnS54YXsx3SI3\ncqkY9Ck3/7HEVOdhaLeelXen1zpjnSDhTDAFjLIXycfryjuPq3NWEKSveVHloBBE\n2qD4MIrobJsBRveyOHjKD8yyL1vFXiIoy7hwZHzXi+l+Nzo0YFgJ864CTrXXzOHk\nO7kXi9+c3v8ib5Pu8dufcw==\n-----END PRIVATE KEY-----\n');

/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table messages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `messages`;

CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int DEFAULT NULL,
  `receiver_id` int DEFAULT NULL,
  `content` text COLLATE utf8mb4_general_ci,
  `timestamp` datetime DEFAULT NULL,
  `is_group_message` tinyint(1) DEFAULT NULL,
  `encrypted_for_user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_messages_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `content`, `timestamp`, `is_group_message`, `encrypted_for_user_id`)
VALUES
	(1,1,1,'Welcome to the Fun Group! This will be our space to chill and share ideas.','2024-11-11 12:45:16',1,NULL),
	(2,2,1,'Thanks, Alice! This is awesome. We can use this space for our project discussions as well.','2024-11-11 12:45:16',1,NULL),
	(3,3,1,'Absolutely! And also share some fun stuff. Speaking of which, did you guys see that new movie trailer?','2024-11-11 12:45:16',1,NULL),
	(4,1,1,'Yes, it looks amazing! Can\'t wait for it to be released.','2024-11-11 12:45:17',1,NULL),
	(5,2,1,'Count me in for the first show! By the way, Charlie, do you still have those notes from last week\'s meeting?','2024-11-11 12:45:17',1,NULL),
	(6,3,1,'Sure, I\'ll upload them here. This group is going to be so useful.','2024-11-11 12:45:17',1,NULL),
	(7,1,1,'Great! Let\'s also share some fun memes to keep things light-hearted.','2024-11-11 12:45:17',1,NULL),
	(8,2,1,'Absolutely! This is going to be a fun and productive space.','2024-11-11 12:45:17',1,NULL),
	(9,3,1,'Hey, what do you all think about starting a book club?','2024-11-11 12:45:17',1,NULL),
	(10,1,1,'That sounds like a great idea! I\'m in.','2024-11-11 12:45:17',1,NULL),
	(11,2,1,'Count me in too! Let\'s choose a book and set a schedule.','2024-11-11 12:45:17',1,NULL),
	(12,3,1,'Awesome! I\'ll suggest a few books and we can vote on one.','2024-11-11 12:45:17',1,NULL),
	(13,1,1,'Perfect! This group is already turning into a hub of activity. Can\'t wait to see what else we do here!','2024-11-11 12:45:17',1,NULL),
	(14,2,1,'Me too! Looking forward to our meetings and discussions.','2024-11-11 12:45:17',1,NULL),
	(15,1,1,'By the way, has anyone tried the new cafe downtown? I\'ve heard great things.','2024-11-11 12:45:17',1,NULL),
	(16,3,1,'Yes! I was there last weekend. The coffee is amazing, and the ambiance is perfect for reading.','2024-11-11 12:45:17',1,NULL),
	(17,2,1,'Sounds like a perfect spot for our book club meetings. Let\'s check it out!','2024-11-11 12:45:17',1,NULL),
	(18,1,1,'Agreed! Maybe we can go there after our project meeting tomorrow.','2024-11-11 12:45:17',1,NULL),
	(19,3,1,'Sure! I\'ll bring some sample chapters from the books I have in mind.','2024-11-11 12:45:17',1,NULL),
	(20,2,1,'Great idea! This is going to be fun.','2024-11-11 12:45:17',1,NULL),
	(21,1,1,'I just saw the funniest meme about remote work. I\'ll share it here.','2024-11-11 12:45:17',1,NULL),
	(22,2,1,'Haha, this is hilarious! It totally resonates with me.','2024-11-11 12:45:17',1,NULL),
	(23,3,1,'Same here! Working from home has its own set of challenges.','2024-11-11 12:45:17',1,NULL),
	(24,1,1,'True! But I wouldn\'t trade it for anything else. I love the flexibility.','2024-11-11 12:45:17',1,NULL),
	(25,2,1,'Agreed! Plus, no commuting means more time for hobbies.','2024-11-11 12:45:17',1,NULL),
	(26,3,1,'Speaking of hobbies, I\'m thinking about picking up guitar lessons. Anyone interested?','2024-11-11 12:45:17',1,NULL),
	(27,1,1,'I would love to learn guitar! Count me in.','2024-11-11 12:45:17',1,NULL),
	(28,2,1,'Me too! Maybe we can find a tutor together.','2024-11-11 12:45:17',1,NULL),
	(29,3,1,'Awesome! I\'ll do some research and let you guys know.','2024-11-11 12:45:17',1,NULL),
	(30,1,1,'So, what\'s everyone doing this weekend?','2024-11-11 12:45:17',1,NULL),
	(31,2,1,'I was thinking about hiking. There\'s a new trail that just opened up.','2024-11-11 12:45:17',1,NULL),
	(32,3,1,'Hiking sounds great! Can I join?','2024-11-11 12:45:17',1,NULL),
	(33,1,1,'Count me in too! I could use some fresh air and exercise.','2024-11-11 12:45:17',1,NULL),
	(34,2,1,'Perfect! Let\'s meet at the trailhead at 9 AM on Saturday.','2024-11-11 12:45:17',1,NULL),
	(35,3,1,'See you all there! Can\'t wait for some adventure.','2024-11-11 12:45:17',1,NULL),
	(36,1,1,'Me too! This is going to be a great weekend.','2024-11-11 12:45:17',1,NULL),
	(37,1,1,'Anyone up for a movie night this weekend?','2024-11-11 12:45:17',1,NULL),
	(38,3,1,'I\'m in! There\'s a new thriller I\'ve been wanting to watch.','2024-11-11 12:45:17',1,NULL),
	(39,2,1,'Count me in too! I love thrillers. Let\'s do it!','2024-11-11 12:45:17',1,NULL),
	(40,1,1,'Great! How about Saturday evening after the hike?','2024-11-11 12:45:17',1,NULL),
	(41,3,1,'Perfect timing. We can grab some food and then enjoy the movie.','2024-11-11 12:45:17',1,NULL),
	(42,2,1,'I\'m looking forward to it. This weekend is going to be packed with fun!','2024-11-11 12:45:17',1,NULL),
	(43,1,1,'Absolutely! Can\'t wait to hang out with you all.','2024-11-11 12:45:17',1,NULL),
	(44,3,1,'Same here. It\'s great to have friends who enjoy the same activities.','2024-11-11 12:45:17',1,NULL),
	(45,2,1,'Couldn\'t agree more. This group is the best!','2024-11-11 12:45:17',1,NULL),
	(46,1,1,'abac','2024-11-11 15:05:14',1,NULL);

/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_message_status
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_message_status`;

CREATE TABLE `user_message_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_user_message_status_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `user_message_status` WRITE;
/*!40000 ALTER TABLE `user_message_status` DISABLE KEYS */;

INSERT INTO `user_message_status` (`id`, `message_id`, `user_id`, `status`)
VALUES
	(1,1,1,'read'),
	(2,1,2,'read'),
	(3,1,3,'sent'),
	(4,2,1,'read'),
	(5,2,2,'read'),
	(6,2,3,'sent'),
	(7,3,1,'read'),
	(8,3,2,'read'),
	(9,3,3,'read'),
	(10,4,1,'read'),
	(11,4,2,'read'),
	(12,4,3,'sent'),
	(13,5,1,'read'),
	(14,5,2,'read'),
	(15,5,3,'sent'),
	(16,6,1,'read'),
	(17,6,2,'read'),
	(18,6,3,'read'),
	(19,7,1,'read'),
	(20,7,2,'read'),
	(21,7,3,'sent'),
	(22,8,1,'read'),
	(23,8,2,'read'),
	(24,8,3,'sent'),
	(25,9,1,'read'),
	(26,9,2,'read'),
	(27,9,3,'read'),
	(28,10,1,'read'),
	(29,10,2,'read'),
	(30,10,3,'sent'),
	(31,11,1,'read'),
	(32,11,2,'read'),
	(33,11,3,'sent'),
	(34,12,1,'read'),
	(35,12,2,'read'),
	(36,12,3,'read'),
	(37,13,1,'read'),
	(38,13,2,'read'),
	(39,13,3,'sent'),
	(40,14,1,'read'),
	(41,14,2,'read'),
	(42,14,3,'sent'),
	(43,15,1,'read'),
	(44,15,2,'read'),
	(45,15,3,'sent'),
	(46,16,1,'read'),
	(47,16,2,'read'),
	(48,16,3,'read'),
	(49,17,1,'read'),
	(50,17,2,'read'),
	(51,17,3,'sent'),
	(52,18,1,'read'),
	(53,18,2,'read'),
	(54,18,3,'sent'),
	(55,19,1,'read'),
	(56,19,2,'read'),
	(57,19,3,'read'),
	(58,20,1,'read'),
	(59,20,2,'read'),
	(60,20,3,'sent'),
	(61,21,1,'read'),
	(62,21,2,'read'),
	(63,21,3,'sent'),
	(64,22,1,'read'),
	(65,22,2,'read'),
	(66,22,3,'sent'),
	(67,23,1,'read'),
	(68,23,2,'read'),
	(69,23,3,'read'),
	(70,24,1,'read'),
	(71,24,2,'read'),
	(72,24,3,'sent'),
	(73,25,1,'read'),
	(74,25,2,'read'),
	(75,25,3,'sent'),
	(76,26,1,'read'),
	(77,26,2,'read'),
	(78,26,3,'read'),
	(79,27,1,'read'),
	(80,27,2,'read'),
	(81,27,3,'sent'),
	(82,28,1,'read'),
	(83,28,2,'read'),
	(84,28,3,'sent'),
	(85,29,1,'read'),
	(86,29,2,'read'),
	(87,29,3,'read'),
	(88,30,1,'read'),
	(89,30,2,'read'),
	(90,30,3,'sent'),
	(91,31,1,'read'),
	(92,31,2,'read'),
	(93,31,3,'sent'),
	(94,32,1,'read'),
	(95,32,2,'read'),
	(96,32,3,'read'),
	(97,33,1,'read'),
	(98,33,2,'read'),
	(99,33,3,'sent'),
	(100,34,1,'read'),
	(101,34,2,'read'),
	(102,34,3,'sent'),
	(103,35,1,'read'),
	(104,35,2,'read'),
	(105,35,3,'read'),
	(106,36,1,'read'),
	(107,36,2,'read'),
	(108,36,3,'sent'),
	(109,37,1,'read'),
	(110,37,2,'read'),
	(111,37,3,'sent'),
	(112,38,1,'read'),
	(113,38,2,'read'),
	(114,38,3,'read'),
	(115,39,1,'read'),
	(116,39,2,'read'),
	(117,39,3,'sent'),
	(118,40,1,'read'),
	(119,40,2,'read'),
	(120,40,3,'sent'),
	(121,41,1,'read'),
	(122,41,2,'read'),
	(123,41,3,'read'),
	(124,42,1,'read'),
	(125,42,2,'read'),
	(126,42,3,'sent'),
	(127,43,1,'read'),
	(128,43,2,'read'),
	(129,43,3,'sent'),
	(130,44,1,'read'),
	(131,44,2,'read'),
	(132,44,3,'read'),
	(133,45,1,'read'),
	(134,45,2,'read'),
	(135,45,3,'sent'),
	(136,46,1,'read'),
	(137,46,2,'read'),
	(138,46,3,'sent');

/*!40000 ALTER TABLE `user_message_status` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `hashed_password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `profile_picture` text COLLATE utf8mb4_general_ci,
  `is_typing` tinyint(1) DEFAULT NULL,
  `typing_chat_id` int DEFAULT NULL,
  `public_key` text COLLATE utf8mb4_general_ci,
  `private_key` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_users_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `username`, `full_name`, `hashed_password`, `profile_picture`, `is_typing`, `typing_chat_id`, `public_key`, `private_key`)
VALUES
	(1,'alice','Alice Wonderland','$2b$12$S7i6NWiPY6q6ln8TKb/.R.YzC3YwB15aPAwhH29CRbBYt0yzJQryO',NULL,0,1,'-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnTEhMgNUwVO1JFvvxEtM\nboGV61j9oMfU2GpJHq4qUB8e7gGRSguagsFTmH+VcBxYtnMPwhiASy49lhiOtFwG\nMFBLsPRMFJk4malv/DYsqGjhxFK8dFwo+r4IR755+Mk3dlaplTOEWaR+owTOvwP5\nGWWE0xqnwuhkiCEytmstZ+fLc+V72IQF2BhtH4c8pPfxiWaA/BGi8jPMNTjK+ZJd\nio0pxNPN8hlojdb8s64+/59Zs5uHc8QMVxwpGZ+9sQ4b+86K0WBNIRepr2yrtLCF\n4Zdbx8Bg4N3UFDfCEBzfQ2BJvLcarb87t+rn9wXiKSilAeHh19bWCQOP/aZrZ0x7\ngwIDAQAB\n-----END PUBLIC KEY-----\n','-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCdMSEyA1TBU7Uk\nW+/ES0xugZXrWP2gx9TYakkeripQHx7uAZFKC5qCwVOYf5VwHFi2cw/CGIBLLj2W\nGI60XAYwUEuw9EwUmTiZqW/8NiyoaOHEUrx0XCj6vghHvnn4yTd2VqmVM4RZpH6j\nBM6/A/kZZYTTGqfC6GSIITK2ay1n58tz5XvYhAXYGG0fhzyk9/GJZoD8EaLyM8w1\nOMr5kl2KjSnE083yGWiN1vyzrj7/n1mzm4dzxAxXHCkZn72xDhv7zorRYE0hF6mv\nbKu0sIXhl1vHwGDg3dQUN8IQHN9DYEm8txqtvzu36uf3BeIpKKUB4eHX1tYJA4/9\npmtnTHuDAgMBAAECggEACio5KVDJ1E6jchx33su3v5Wlqjhw/kqt2ujUnaVJmzDI\nAUAcsxsY/Mefrkbh1QQgQHwkUrre4P22gdRItiUVSV6H5oOFv/dAj79DPJ4MOT+/\nCcEH6sZi6AQN6QXKQWpRqddk0/8m2d0nS0duTy/kld3YvwYEPzhj9+Gds+ouX3+l\nv2/p2j+wJOhJH6KlcuJXkffDLBgeUPguseBSacvotwz23z5xoj6A/zHlVlJg2GmN\nHlfLMzAsbaboCAsit8mV2CaO5fVS79AIEKSmfGcociaXmwwZThndfYLhuVWFazNo\npn28ZppjGBSUcR4PH+nZjBPtT92uDRAab6KcUy40gQKBgQDa22WHvd5WPDYleiUL\nDucgPnH2rCC5blp7v4YXLGg37OXD2Yx83lc9cXpDO5128xSxKI4qv3/Q8bN9D9b0\nXd1GYmp5hMODaAP8w6tLxip2Scv/4IY2oeblPvKYNc01/iVi6xAn5TS1f5TcesQB\n4R9zkXwhCXHeCAnaV1ZV6AX34QKBgQC33pdQJx5aZpR5qraTWeoCccavDDVjOj6T\nJO82JmzN2TvCcr/0X3/Ej1IuhbwFnX3hc64wq11DYVdqQl/gOTKrNdFWvBu0/tj3\n53vW/QrnCr6RUuNmo8WLrzEnqkYSVT+AYG2hNwlGKWAKapar2cv5YwTmJkkQ94r0\nm70t6euP4wKBgQCdA45B5pwerjACjzEIT/bNkT9dw3vuzRcpdOyUr41Noi3tZqR9\n6V4ZfNJEbf64mgicWQY18RGYK++jp7uFsdnQZ0cQS4mhOvyxWQgJ4vAP0T4EI2bm\nxxzKF3Egdmj1dZII96+tj6lTFWcNDx6UYpiX5yZw5T/GFWpMNSCBnWa6wQKBgA+C\nXxELu6u0a2G33J6hPvPl1PR++yHbj9upiePvac4TPM8yDq72Pzi9PhlefnWayztx\nHohMbBl65Hy6DIxFRtjaOUYvp8akmHiQtgl0Xq8OYPSxIS1PMyKNLIBEBJUXS7vw\nZk7q7YVViBxY0Uy9mk724zrmj9M2jioD2Pk+efgxAoGANSfsgixJ++3rJIFRNoys\nLQZqJ2hTEBHEMyi+hmbkjaEykEGLZS5g8EtaywFD5v1nDHDZUIxtHO+SNX+OYfWE\nUysoP1lruiZtE85RQD9FLg4GpuhyocbJqRyeF1TT3SM54qcSG839rjNjHJ10esvp\n8b2bqSGWZJIf187si3q6YPU=\n-----END PRIVATE KEY-----\n'),
	(2,'bob','Bob Builder','$2b$12$7dxX79eC8awc2cK6CyzaDOCb7me72BhJGcdWstQHcjmXJV9tUthcC',NULL,0,1,'-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6rg2uQq0t4NRBEYH/xLk\nf6EJfnxroZWSaevvdcFQRlu9deSamN5GG9AFfO1vlwatRqna9TXDG8ih99p3L/Xi\nOdxUKfL9jpHdnpXTE8QtUP0DXdhP4zsbTWpXntn3lE4cADyju40TRnGTzDjNvNX4\nq/FT6kYBBPYJ1VflI36bcWfZSiEOHqw6wdxz1QxwLsiejktXmOQrWzfwV5m/7ycf\nJygO1ac/wViN9rwjCT1kkxCqymYzZPeN0z8ZwX9SUvYiQpy3GG5hKGX+cKHXHluY\nua3fNijO0t9ZXR7AGFTZ69RGFO+ss7vJUamcAkChCWPu5xKdiRv34BiDGvSkhgkU\nZwIDAQAB\n-----END PUBLIC KEY-----\n','-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDquDa5CrS3g1EE\nRgf/EuR/oQl+fGuhlZJp6+91wVBGW7115JqY3kYb0AV87W+XBq1Gqdr1NcMbyKH3\n2ncv9eI53FQp8v2Okd2eldMTxC1Q/QNd2E/jOxtNalee2feUThwAPKO7jRNGcZPM\nOM281fir8VPqRgEE9gnVV+UjfptxZ9lKIQ4erDrB3HPVDHAuyJ6OS1eY5CtbN/BX\nmb/vJx8nKA7Vpz/BWI32vCMJPWSTEKrKZjNk943TPxnBf1JS9iJCnLcYbmEoZf5w\nodceW5i5rd82KM7S31ldHsAYVNnr1EYU76yzu8lRqZwCQKEJY+7nEp2JG/fgGIMa\n9KSGCRRnAgMBAAECggEAAZ3u0wSRvlcAYMGcbf+29kDhQlDUM22kQvyVdC7/qag6\nJZH2KcHbH0q8cdzlBoK8pzVu/XJ7NtDzUZO6Ikp4cJ/3FhSz4YVFGfy84uFEKLb+\nP3W4b/2Wtw90GzZYZ8XL6dqx2TLNvtDj4UIbxl7XZBeFTYXv2lI0sMVN/YvaGsVt\nGJSSIG7bHeGZ0dBIGEonL0nrzZgw2VCp8rOz8GT55gsPZ/e01FBRdcQq8UPm7GzF\nlHPAKubZZauw7zVgyRxND8f1oZOVM8qIT8g3oKlFKwDe/8av0wuQqBcBQb58NCkb\nF41fP5BbjGn7eYld1D3JT7oLKUWuU2XHC1gSUt1biQKBgQD7BELGOmMKCn91Nrby\ngTm8PmMSOFLjEY46UKW454e890AxbmcJBCbOaxGGRRuV6xKsfzC5+NM+KOZuKLWF\nLH+C076H6vR6S4rGjMv9hXCGp920SGUb48qxMcJSjAdU61M4AQgGhDakCA8WfEMk\nStXQuqwTgmhpfXjvWkfxOL7NjwKBgQDvYSBmIbKtId2crWN682t6BNz4/4a9HxLk\nOzzbY5ypRHtkI+l1oy80DRchphKbLkrGXhNkoU2vHVsMxTaxtG9aBfVPxoSwPxdG\nb8YlR8gbBMDseJVg+SgUDYuAqMBln8rf1Bag45pVFrpoBaxD8Xy3fKtSiKkniSMM\n9BjPiXgPqQKBgGnM3vQ8Udg+moBmInBOZW5hgVKBqPYKRT9xFJi+Belw8X6kQQt8\n03p3iHhmknz7CvDn3zrTlP4DMTTHNdM+8TPMWedh8c/GHWUYnTZrUwV+paTCStOZ\njKppBbXTTZfOZFIbpS1R9tHmj61zjL00SbDjrXm/opCsERgZnm8e8tUjAoGBAL/l\nU6ysDOlfwaENGjeBFcKOTXpKlX/cfi96EXIqK3dCD8yaQVfthjSq3cU6taWy+XyG\nA/PinzznQos9OXhBlhZLunjGQq5rFUSA7A4Muix2phWrIMzJT8irhw6PuRR+gYrn\nIXC+pITboHktOwiIeRs6lLioFzo7ZF7I+2673ARpAoGAMbgccFHR9QD/XbDc8qH5\na2MGqPwYy6K+dlIJZhcbE5csIGbr09onXhuYk3kCe+N952MXpscK18iQRN6t7fei\ne5mngnY1jR/7/B7EzdrlSQLAaHs+pjXQ/f4ig18zMoOE4mtIZ+65o6i7birU08xQ\n1WraRQGFVPN6zpqMsU0s38U=\n-----END PRIVATE KEY-----\n'),
	(3,'charlie','Charlie Brown','$2b$12$h4PHepT6T5f6T0800PnsN.kp/atsojWPog36Mf/k9T62szKaX9ja6',NULL,0,NULL,'-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA21lkcF3gJUqWu8sEYzBb\nN/m6Hfypmi7kUA8xYxWf7LruHdftXgEJkLMJYOC006dvTUI1t87NK1BTnZJhFTeM\nHgUmy72vInvcrkJIVpoyHC3WoomfZZGgpwIx0n+dfXqoiKE3XJNLtMEIMocphXRC\nOyHg9HYBv5NVoWADbWf4ER5DPSK2cM9DdGsUaUWxbCqhaaQB+gxJWeJOvAy2s7nN\nFhodeWOjbH9ZrnXPMAOhTXgksO+ZDvtHNEamIIrbCMRJJVv6aIIJztHNtCv/TiRo\nrTZBHQbzhrusjtG8i+MhkqSXNqJU60K0V745/72HV1e0d3uTeHg/eWyfIG7Ex1W7\nZQIDAQAB\n-----END PUBLIC KEY-----\n','-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDbWWRwXeAlSpa7\nywRjMFs3+bod/KmaLuRQDzFjFZ/suu4d1+1eAQmQswlg4LTTp29NQjW3zs0rUFOd\nkmEVN4weBSbLva8ie9yuQkhWmjIcLdaiiZ9lkaCnAjHSf519eqiIoTdck0u0wQgy\nhymFdEI7IeD0dgG/k1WhYANtZ/gRHkM9IrZwz0N0axRpRbFsKqFppAH6DElZ4k68\nDLazuc0WGh15Y6Nsf1mudc8wA6FNeCSw75kO+0c0RqYgitsIxEklW/poggnO0c20\nK/9OJGitNkEdBvOGu6yO0byL4yGSpJc2olTrQrRXvjn/vYdXV7R3e5N4eD95bJ8g\nbsTHVbtlAgMBAAECggEAOhTSESTyaL1261QHHeKcjNZd73nLSQ3Ym9BiEewUdEFN\nMu7NpiIdL8kQlyv5BcBkqu74vWqPjkQPV/5+IXmbawmPK8zW1ok4tpXLhM8ArNCA\ncHqDkAf/I6njmmr7P1Ie1UrnF2bTWZHxgzuiBXny3aiLYf/rV5iCSKBdV/d7SsCc\npgM7nw6T5sUaZcx4kGJB8u/gyX9sX2lsSQUslEY9QtZzPWDLRxQ45PKxPLY2K4QA\nwyzJksejFHkBbYUvz1D8PWmzD9v8OTkaTBY1r/eK0R5UDv45h0ZGk2ifqkWxr1aR\naWDBPeSfHsz75LiBTvp3r89Jt1fSB1kHzMLDpuq+IwKBgQDxdolZU2u631NbhRX0\nFUHp/HwPWoVN8FubCpEa1mtEHgAbx4CHoVU51ZlEiXIQAen22bOqQKf+BDqRCll6\na/7YhRtn7WRlnz+DtMF6xFhE6stNcASOH2FQCu42mZlbJDhEvlMXQ0PEC2Zwaj3u\n+zi9xG6tYhUDzDfQdasrHtucBwKBgQDojgi12gF8CbrVV5gGJKEXHsQf5EazrOMb\nINUBQZYtjKi/GWT/i5csDUvjMajEVX0Er+8SJqKu/1lvsYmvjtsO6suaecXMh5eb\nXCXBGavDGBpfmsWJQFJnpJVyYwDg37rjUkEOEj4Er8zA83SxZPQP7cGxPl19M+n1\n43SPV/+qMwKBgQCCptX4rGe9TLuo6KERWjM5LXHfSOaaXnTitlv/foe56tW6Mj+8\no7IewhHVgN1kBfUXqYJKnAOKMbWS51u1HxxdAeDrYgsR5ZITbMnH6NeuKrForDT6\nxcX87n0otAHDzBxaLfV9v9q6CEUcjJAIcIyqOdB9JnYigOyucgz1HxRLHwKBgAs/\no4g4TU4UombjX8UcTHZz1IS+Y/UY7btIMUVoSL1XSmpD7jC2Lc/BrOQGaOVmRS/O\n2r+EAuZ4D3lpmwFU5Z+pF8QXE8w62sh3ApR+i2JabhwlvlxPMi01Ns1boJU//Sg1\nuFPX6gwL/NlwbTqPaYbDt1S9cYQ22KA+KksstH8lAoGARpHdw/JzpHMELGFXutet\n0cThsn9fYW5kql+j0yGAgjzjqWr7Aqjx8hNJs1HTa99RjVLzApR8e/IVjsBGlF4o\n97RFW96kduv/LU+5FEFb/+fFWjpdehGVBrjVJR/Mh6TeX+Xcb0PTb1wUi4rIK3vC\n3HxDs6jsJfWVC2WiIf0Td2k=\n-----END PRIVATE KEY-----\n');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
