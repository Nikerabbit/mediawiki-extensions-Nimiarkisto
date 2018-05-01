-- MySQL dump 10.14  Distrib 5.5.56-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: narkisto
-- ------------------------------------------------------
-- Server version	5.5.56-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `archive`
--

DROP TABLE IF EXISTS `archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `archive` (
  `ar_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ar_namespace` int(11) NOT NULL DEFAULT '0',
  `ar_title` varbinary(255) NOT NULL DEFAULT '',
  `ar_text` mediumblob NOT NULL,
  `ar_comment` varbinary(767) NOT NULL DEFAULT '',
  `ar_comment_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `ar_user` int(10) unsigned NOT NULL DEFAULT '0',
  `ar_user_text` varbinary(255) NOT NULL,
  `ar_timestamp` binary(14) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `ar_minor_edit` tinyint(4) NOT NULL DEFAULT '0',
  `ar_flags` tinyblob NOT NULL,
  `ar_rev_id` int(10) unsigned DEFAULT NULL,
  `ar_text_id` int(10) unsigned DEFAULT NULL,
  `ar_deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ar_len` int(10) unsigned DEFAULT NULL,
  `ar_page_id` int(10) unsigned DEFAULT NULL,
  `ar_parent_id` int(10) unsigned DEFAULT NULL,
  `ar_sha1` varbinary(32) NOT NULL DEFAULT '',
  `ar_content_model` varbinary(32) DEFAULT NULL,
  `ar_content_format` varbinary(64) DEFAULT NULL,
  PRIMARY KEY (`ar_id`),
  KEY `name_title_timestamp` (`ar_namespace`,`ar_title`,`ar_timestamp`),
  KEY `usertext_timestamp` (`ar_user_text`,`ar_timestamp`),
  KEY `ar_revid` (`ar_rev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archive`
--

LOCK TABLES `archive` WRITE;
/*!40000 ALTER TABLE `archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_passwords`
--

DROP TABLE IF EXISTS `bot_passwords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bot_passwords` (
  `bp_user` int(10) unsigned NOT NULL,
  `bp_app_id` varbinary(32) NOT NULL,
  `bp_password` tinyblob NOT NULL,
  `bp_token` binary(32) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `bp_restrictions` blob NOT NULL,
  `bp_grants` blob NOT NULL,
  PRIMARY KEY (`bp_user`,`bp_app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_passwords`
--

LOCK TABLES `bot_passwords` WRITE;
/*!40000 ALTER TABLE `bot_passwords` DISABLE KEYS */;
/*!40000 ALTER TABLE `bot_passwords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `cat_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cat_title` varbinary(255) NOT NULL,
  `cat_pages` int(11) NOT NULL DEFAULT '0',
  `cat_subcats` int(11) NOT NULL DEFAULT '0',
  `cat_files` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cat_id`),
  UNIQUE KEY `cat_title` (`cat_title`),
  KEY `cat_pages` (`cat_pages`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Imported_vocabulary',7,0,0);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorylinks`
--

DROP TABLE IF EXISTS `categorylinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorylinks` (
  `cl_from` int(10) unsigned NOT NULL DEFAULT '0',
  `cl_to` varbinary(255) NOT NULL DEFAULT '',
  `cl_sortkey` varbinary(230) NOT NULL DEFAULT '',
  `cl_sortkey_prefix` varbinary(255) NOT NULL DEFAULT '',
  `cl_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cl_collation` varbinary(32) NOT NULL DEFAULT '',
  `cl_type` enum('page','subcat','file') NOT NULL DEFAULT 'page',
  PRIMARY KEY (`cl_from`,`cl_to`),
  KEY `cl_sortkey` (`cl_to`,`cl_type`,`cl_sortkey`,`cl_from`),
  KEY `cl_timestamp` (`cl_to`,`cl_timestamp`),
  KEY `cl_collation_ext` (`cl_collation`,`cl_to`,`cl_type`,`cl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorylinks`
--

LOCK TABLES `categorylinks` WRITE;
/*!40000 ALTER TABLE `categorylinks` DISABLE KEYS */;
INSERT INTO `categorylinks` VALUES (2,'Imported_vocabulary','SMW IMPORT SKOS','','2017-12-05 18:06:16','uppercase','page'),(3,'Imported_vocabulary','SMW IMPORT FOAF','','2017-12-05 18:06:16','uppercase','page'),(4,'Imported_vocabulary','SMW IMPORT OWL','','2017-12-05 18:06:17','uppercase','page'),(5,'Imported_vocabulary','FOAF:KNOWS','','2017-12-05 18:06:17','uppercase','page'),(6,'Imported_vocabulary','FOAF:NAME','','2017-12-05 18:06:17','uppercase','page'),(7,'Imported_vocabulary','FOAF:HOMEPAGE','','2017-12-05 18:06:17','uppercase','page'),(8,'Imported_vocabulary','OWL:DIFFERENTFROM','','2017-12-05 18:06:17','uppercase','page');
/*!40000 ALTER TABLE `categorylinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `change_tag`
--

DROP TABLE IF EXISTS `change_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `change_tag` (
  `ct_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ct_rc_id` int(11) DEFAULT NULL,
  `ct_log_id` int(10) unsigned DEFAULT NULL,
  `ct_rev_id` int(10) unsigned DEFAULT NULL,
  `ct_tag` varbinary(255) NOT NULL,
  `ct_params` blob,
  PRIMARY KEY (`ct_id`),
  UNIQUE KEY `change_tag_rc_tag` (`ct_rc_id`,`ct_tag`),
  UNIQUE KEY `change_tag_log_tag` (`ct_log_id`,`ct_tag`),
  UNIQUE KEY `change_tag_rev_tag` (`ct_rev_id`,`ct_tag`),
  KEY `change_tag_tag_id` (`ct_tag`,`ct_rc_id`,`ct_rev_id`,`ct_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `change_tag`
--

LOCK TABLES `change_tag` WRITE;
/*!40000 ALTER TABLE `change_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `change_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `comment_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_hash` int(11) NOT NULL,
  `comment_text` blob NOT NULL,
  `comment_data` blob,
  PRIMARY KEY (`comment_id`),
  KEY `comment_hash` (`comment_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `externallinks`
--

DROP TABLE IF EXISTS `externallinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `externallinks` (
  `el_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `el_from` int(10) unsigned NOT NULL DEFAULT '0',
  `el_to` blob NOT NULL,
  `el_index` blob NOT NULL,
  `el_index_60` varbinary(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`el_id`),
  KEY `el_from` (`el_from`,`el_to`(40)),
  KEY `el_to` (`el_to`(60),`el_from`),
  KEY `el_index` (`el_index`(60)),
  KEY `el_index_60` (`el_index_60`,`el_id`),
  KEY `el_from_index_60` (`el_from`,`el_index_60`,`el_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `externallinks`
--

LOCK TABLES `externallinks` WRITE;
/*!40000 ALTER TABLE `externallinks` DISABLE KEYS */;
INSERT INTO `externallinks` VALUES (1,2,'http://www.w3.org/TR/skos-reference/skos.rdf','http://org.w3.www./TR/skos-reference/skos.rdf',''),(2,2,'http://www.w3.org/2004/02/skos/core#%7C','http://org.w3.www./2004/02/skos/core#%7C',''),(3,3,'http://www.foaf-project.org/','http://org.foaf-project.www./',''),(4,3,'http://xmlns.com/foaf/0.1/%7C','http://com.xmlns./foaf/0.1/%7C',''),(5,4,'http://www.w3.org/2002/07/owl','http://org.w3.www./2002/07/owl',''),(6,4,'http://www.w3.org/2002/07/owl#%7C','http://org.w3.www./2002/07/owl#%7C','');
/*!40000 ALTER TABLE `externallinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filearchive`
--

DROP TABLE IF EXISTS `filearchive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filearchive` (
  `fa_id` int(11) NOT NULL AUTO_INCREMENT,
  `fa_name` varbinary(255) NOT NULL DEFAULT '',
  `fa_archive_name` varbinary(255) DEFAULT '',
  `fa_storage_group` varbinary(16) DEFAULT NULL,
  `fa_storage_key` varbinary(64) DEFAULT '',
  `fa_deleted_user` int(11) DEFAULT NULL,
  `fa_deleted_timestamp` binary(14) DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `fa_deleted_reason` varbinary(767) DEFAULT '',
  `fa_deleted_reason_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fa_size` int(10) unsigned DEFAULT '0',
  `fa_width` int(11) DEFAULT '0',
  `fa_height` int(11) DEFAULT '0',
  `fa_metadata` mediumblob,
  `fa_bits` int(11) DEFAULT '0',
  `fa_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `fa_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') DEFAULT 'unknown',
  `fa_minor_mime` varbinary(100) DEFAULT 'unknown',
  `fa_description` varbinary(767) DEFAULT '',
  `fa_description_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fa_user` int(10) unsigned DEFAULT '0',
  `fa_user_text` varbinary(255) DEFAULT NULL,
  `fa_timestamp` binary(14) DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `fa_deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `fa_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`fa_id`),
  KEY `fa_name` (`fa_name`,`fa_timestamp`),
  KEY `fa_storage_group` (`fa_storage_group`,`fa_storage_key`),
  KEY `fa_deleted_timestamp` (`fa_deleted_timestamp`),
  KEY `fa_user_timestamp` (`fa_user_text`,`fa_timestamp`),
  KEY `fa_sha1` (`fa_sha1`(10))
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filearchive`
--

LOCK TABLES `filearchive` WRITE;
/*!40000 ALTER TABLE `filearchive` DISABLE KEYS */;
/*!40000 ALTER TABLE `filearchive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_ext_ref`
--

DROP TABLE IF EXISTS `flow_ext_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flow_ext_ref` (
  `ref_id` binary(11) NOT NULL,
  `ref_src_wiki` varbinary(16) NOT NULL,
  `ref_src_object_id` binary(11) NOT NULL,
  `ref_src_object_type` varbinary(32) NOT NULL,
  `ref_src_workflow_id` binary(11) NOT NULL,
  `ref_src_namespace` int(11) NOT NULL,
  `ref_src_title` varbinary(255) NOT NULL,
  `ref_target` blob NOT NULL,
  `ref_type` varbinary(16) NOT NULL,
  PRIMARY KEY (`ref_id`),
  KEY `flow_ext_ref_idx_v3` (`ref_src_wiki`,`ref_src_namespace`,`ref_src_title`,`ref_type`,`ref_target`(255),`ref_src_object_type`,`ref_src_object_id`),
  KEY `flow_ext_ref_revision_v2` (`ref_src_wiki`,`ref_src_namespace`,`ref_src_title`,`ref_src_object_type`,`ref_src_object_id`,`ref_type`,`ref_target`(255))
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_ext_ref`
--

LOCK TABLES `flow_ext_ref` WRITE;
/*!40000 ALTER TABLE `flow_ext_ref` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_ext_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_revision`
--

DROP TABLE IF EXISTS `flow_revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flow_revision` (
  `rev_id` binary(11) NOT NULL,
  `rev_type` varbinary(16) NOT NULL,
  `rev_type_id` binary(11) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0',
  `rev_user_id` bigint(20) unsigned NOT NULL,
  `rev_user_ip` varbinary(39) DEFAULT NULL,
  `rev_user_wiki` varbinary(64) NOT NULL,
  `rev_parent_id` binary(11) DEFAULT NULL,
  `rev_flags` tinyblob NOT NULL,
  `rev_content` mediumblob NOT NULL,
  `rev_change_type` varbinary(255) DEFAULT NULL,
  `rev_mod_state` varbinary(32) NOT NULL,
  `rev_mod_user_id` bigint(20) unsigned DEFAULT NULL,
  `rev_mod_user_ip` varbinary(39) DEFAULT NULL,
  `rev_mod_user_wiki` varbinary(64) DEFAULT NULL,
  `rev_mod_timestamp` varbinary(14) DEFAULT NULL,
  `rev_mod_reason` varbinary(255) DEFAULT NULL,
  `rev_last_edit_id` binary(11) DEFAULT NULL,
  `rev_edit_user_id` bigint(20) unsigned DEFAULT NULL,
  `rev_edit_user_ip` varbinary(39) DEFAULT NULL,
  `rev_edit_user_wiki` varbinary(64) DEFAULT NULL,
  `rev_content_length` int(11) NOT NULL DEFAULT '0',
  `rev_previous_content_length` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`rev_id`),
  UNIQUE KEY `flow_revision_unique_parent` (`rev_parent_id`),
  KEY `flow_revision_type_id` (`rev_type`,`rev_type_id`),
  KEY `flow_revision_user` (`rev_user_id`,`rev_user_ip`,`rev_user_wiki`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_revision`
--

LOCK TABLES `flow_revision` WRITE;
/*!40000 ALTER TABLE `flow_revision` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_revision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_topic_list`
--

DROP TABLE IF EXISTS `flow_topic_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flow_topic_list` (
  `topic_list_id` binary(11) NOT NULL,
  `topic_id` binary(11) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0',
  PRIMARY KEY (`topic_list_id`,`topic_id`),
  KEY `flow_topic_list_topic_id` (`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_topic_list`
--

LOCK TABLES `flow_topic_list` WRITE;
/*!40000 ALTER TABLE `flow_topic_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_topic_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_tree_node`
--

DROP TABLE IF EXISTS `flow_tree_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flow_tree_node` (
  `tree_ancestor_id` binary(11) NOT NULL,
  `tree_descendant_id` binary(11) NOT NULL,
  `tree_depth` smallint(6) NOT NULL,
  PRIMARY KEY (`tree_ancestor_id`,`tree_descendant_id`),
  UNIQUE KEY `flow_tree_constraint` (`tree_descendant_id`,`tree_depth`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_tree_node`
--

LOCK TABLES `flow_tree_node` WRITE;
/*!40000 ALTER TABLE `flow_tree_node` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_tree_node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_tree_revision`
--

DROP TABLE IF EXISTS `flow_tree_revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flow_tree_revision` (
  `tree_rev_descendant_id` binary(11) NOT NULL,
  `tree_rev_id` binary(11) NOT NULL,
  `tree_orig_user_id` bigint(20) unsigned NOT NULL,
  `tree_orig_user_ip` varbinary(39) DEFAULT NULL,
  `tree_orig_user_wiki` varbinary(64) NOT NULL,
  `tree_parent_id` binary(11) DEFAULT NULL,
  PRIMARY KEY (`tree_rev_id`),
  KEY `flow_tree_descendant_rev_id` (`tree_rev_descendant_id`,`tree_rev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_tree_revision`
--

LOCK TABLES `flow_tree_revision` WRITE;
/*!40000 ALTER TABLE `flow_tree_revision` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_tree_revision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_wiki_ref`
--

DROP TABLE IF EXISTS `flow_wiki_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flow_wiki_ref` (
  `ref_id` binary(11) NOT NULL,
  `ref_src_wiki` varbinary(16) NOT NULL,
  `ref_src_object_id` binary(11) NOT NULL,
  `ref_src_object_type` varbinary(32) NOT NULL,
  `ref_src_workflow_id` binary(11) NOT NULL,
  `ref_src_namespace` int(11) NOT NULL,
  `ref_src_title` varbinary(255) NOT NULL,
  `ref_target_namespace` int(11) NOT NULL,
  `ref_target_title` varbinary(255) NOT NULL,
  `ref_type` varbinary(16) NOT NULL,
  PRIMARY KEY (`ref_id`),
  KEY `flow_wiki_ref_idx_v2` (`ref_src_wiki`,`ref_src_namespace`,`ref_src_title`,`ref_type`,`ref_target_namespace`,`ref_target_title`,`ref_src_object_type`,`ref_src_object_id`),
  KEY `flow_wiki_ref_revision_v2` (`ref_src_wiki`,`ref_src_namespace`,`ref_src_title`,`ref_src_object_type`,`ref_src_object_id`,`ref_type`,`ref_target_namespace`,`ref_target_title`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_wiki_ref`
--

LOCK TABLES `flow_wiki_ref` WRITE;
/*!40000 ALTER TABLE `flow_wiki_ref` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_wiki_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_workflow`
--

DROP TABLE IF EXISTS `flow_workflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flow_workflow` (
  `workflow_id` binary(11) NOT NULL,
  `workflow_wiki` varbinary(64) NOT NULL,
  `workflow_namespace` int(11) NOT NULL,
  `workflow_page_id` int(10) unsigned NOT NULL,
  `workflow_title_text` varbinary(255) NOT NULL,
  `workflow_name` varbinary(255) NOT NULL,
  `workflow_last_update_timestamp` binary(14) NOT NULL,
  `workflow_lock_state` int(10) unsigned NOT NULL,
  `workflow_type` varbinary(16) NOT NULL,
  PRIMARY KEY (`workflow_id`),
  KEY `flow_workflow_lookup` (`workflow_wiki`,`workflow_namespace`,`workflow_title_text`),
  KEY `flow_workflow_update_timestamp` (`workflow_last_update_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_workflow`
--

LOCK TABLES `flow_workflow` WRITE;
/*!40000 ALTER TABLE `flow_workflow` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_workflow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image` (
  `img_name` varbinary(255) NOT NULL DEFAULT '',
  `img_size` int(10) unsigned NOT NULL DEFAULT '0',
  `img_width` int(11) NOT NULL DEFAULT '0',
  `img_height` int(11) NOT NULL DEFAULT '0',
  `img_metadata` mediumblob NOT NULL,
  `img_bits` int(11) NOT NULL DEFAULT '0',
  `img_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `img_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') NOT NULL DEFAULT 'unknown',
  `img_minor_mime` varbinary(100) NOT NULL DEFAULT 'unknown',
  `img_description` varbinary(767) NOT NULL DEFAULT '',
  `img_user` int(10) unsigned NOT NULL DEFAULT '0',
  `img_user_text` varbinary(255) NOT NULL,
  `img_timestamp` varbinary(14) NOT NULL DEFAULT '',
  `img_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`img_name`),
  KEY `img_user_timestamp` (`img_user`,`img_timestamp`),
  KEY `img_usertext_timestamp` (`img_user_text`,`img_timestamp`),
  KEY `img_size` (`img_size`),
  KEY `img_timestamp` (`img_timestamp`),
  KEY `img_sha1` (`img_sha1`(10)),
  KEY `img_media_mime` (`img_media_type`,`img_major_mime`,`img_minor_mime`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image`
--

LOCK TABLES `image` WRITE;
/*!40000 ALTER TABLE `image` DISABLE KEYS */;
/*!40000 ALTER TABLE `image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image_comment_temp`
--

DROP TABLE IF EXISTS `image_comment_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image_comment_temp` (
  `imgcomment_name` varbinary(255) NOT NULL,
  `imgcomment_description_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`imgcomment_name`,`imgcomment_description_id`),
  UNIQUE KEY `imgcomment_name` (`imgcomment_name`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_comment_temp`
--

LOCK TABLES `image_comment_temp` WRITE;
/*!40000 ALTER TABLE `image_comment_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `image_comment_temp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagelinks`
--

DROP TABLE IF EXISTS `imagelinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imagelinks` (
  `il_from` int(10) unsigned NOT NULL DEFAULT '0',
  `il_from_namespace` int(11) NOT NULL DEFAULT '0',
  `il_to` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`il_from`,`il_to`),
  KEY `il_to` (`il_to`,`il_from`),
  KEY `il_backlinks_namespace` (`il_from_namespace`,`il_to`,`il_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagelinks`
--

LOCK TABLES `imagelinks` WRITE;
/*!40000 ALTER TABLE `imagelinks` DISABLE KEYS */;
/*!40000 ALTER TABLE `imagelinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interwiki`
--

DROP TABLE IF EXISTS `interwiki`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `interwiki` (
  `iw_prefix` varbinary(32) NOT NULL,
  `iw_url` blob NOT NULL,
  `iw_api` blob NOT NULL,
  `iw_wikiid` varbinary(64) NOT NULL,
  `iw_local` tinyint(1) NOT NULL,
  `iw_trans` tinyint(4) NOT NULL DEFAULT '0',
  UNIQUE KEY `iw_prefix` (`iw_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interwiki`
--

LOCK TABLES `interwiki` WRITE;
/*!40000 ALTER TABLE `interwiki` DISABLE KEYS */;
INSERT INTO `interwiki` VALUES ('acronym','http://www.acronymfinder.com/~/search/af.aspx?string=exact&Acronym=$1','','',0,0),('advogato','http://www.advogato.org/$1','','',0,0),('arxiv','http://www.arxiv.org/abs/$1','','',0,0),('c2find','http://c2.com/cgi/wiki?FindPage&value=$1','','',0,0),('cache','http://www.google.com/search?q=cache:$1','','',0,0),('commons','https://commons.wikimedia.org/wiki/$1','https://commons.wikimedia.org/w/api.php','',0,0),('dictionary','http://www.dict.org/bin/Dict?Database=*&Form=Dict1&Strategy=*&Query=$1','','',0,0),('doi','http://dx.doi.org/$1','','',0,0),('drumcorpswiki','http://www.drumcorpswiki.com/$1','http://drumcorpswiki.com/api.php','',0,0),('dwjwiki','http://www.suberic.net/cgi-bin/dwj/wiki.cgi?$1','','',0,0),('elibre','http://enciclopedia.us.es/index.php/$1','http://enciclopedia.us.es/api.php','',0,0),('emacswiki','http://www.emacswiki.org/cgi-bin/wiki.pl?$1','','',0,0),('foldoc','http://foldoc.org/?$1','','',0,0),('foxwiki','http://fox.wikis.com/wc.dll?Wiki~$1','','',0,0),('freebsdman','http://www.FreeBSD.org/cgi/man.cgi?apropos=1&query=$1','','',0,0),('gentoo-wiki','http://gentoo-wiki.com/$1','','',0,0),('google','http://www.google.com/search?q=$1','','',0,0),('googlegroups','http://groups.google.com/groups?q=$1','','',0,0),('hammondwiki','http://www.dairiki.org/HammondWiki/$1','','',0,0),('hrwiki','http://www.hrwiki.org/wiki/$1','http://www.hrwiki.org/w/api.php','',0,0),('imdb','http://www.imdb.com/find?q=$1&tt=on','','',0,0),('kmwiki','http://kmwiki.wikispaces.com/$1','','',0,0),('linuxwiki','http://linuxwiki.de/$1','','',0,0),('lojban','http://mw.lojban.org/papri/$1','','',0,0),('lqwiki','http://wiki.linuxquestions.org/wiki/$1','','',0,0),('meatball','http://www.usemod.com/cgi-bin/mb.pl?$1','','',0,0),('mediawikiwiki','https://www.mediawiki.org/wiki/$1','https://www.mediawiki.org/w/api.php','',0,0),('memoryalpha','http://en.memory-alpha.org/wiki/$1','http://en.memory-alpha.org/api.php','',0,0),('metawiki','http://sunir.org/apps/meta.pl?$1','','',0,0),('metawikimedia','https://meta.wikimedia.org/wiki/$1','https://meta.wikimedia.org/w/api.php','',0,0),('mozillawiki','http://wiki.mozilla.org/$1','https://wiki.mozilla.org/api.php','',0,0),('mw','https://www.mediawiki.org/wiki/$1','https://www.mediawiki.org/w/api.php','',0,0),('oeis','http://oeis.org/$1','','',0,0),('openwiki','http://openwiki.com/ow.asp?$1','','',0,0),('pmid','https://www.ncbi.nlm.nih.gov/pubmed/$1?dopt=Abstract','','',0,0),('pythoninfo','http://wiki.python.org/moin/$1','','',0,0),('rfc','https://tools.ietf.org/html/rfc$1','','',0,0),('s23wiki','http://s23.org/wiki/$1','http://s23.org/w/api.php','',0,0),('seattlewireless','http://seattlewireless.net/$1','','',0,0),('senseislibrary','http://senseis.xmp.net/?$1','','',0,0),('shoutwiki','http://www.shoutwiki.com/wiki/$1','http://www.shoutwiki.com/w/api.php','',0,0),('squeak','http://wiki.squeak.org/squeak/$1','','',0,0),('theopedia','http://www.theopedia.com/$1','','',0,0),('tmbw','http://www.tmbw.net/wiki/$1','http://tmbw.net/wiki/api.php','',0,0),('tmnet','http://www.technomanifestos.net/?$1','','',0,0),('twiki','http://twiki.org/cgi-bin/view/$1','','',0,0),('uncyclopedia','http://en.uncyclopedia.co/wiki/$1','http://en.uncyclopedia.co/w/api.php','',0,0),('unreal','http://wiki.beyondunreal.com/$1','http://wiki.beyondunreal.com/w/api.php','',0,0),('usemod','http://www.usemod.com/cgi-bin/wiki.pl?$1','','',0,0),('wiki','http://c2.com/cgi/wiki?$1','','',0,0),('wikia','http://www.wikia.com/wiki/$1','','',0,0),('wikibooks','https://en.wikibooks.org/wiki/$1','https://en.wikibooks.org/w/api.php','',0,0),('wikidata','https://www.wikidata.org/wiki/$1','https://www.wikidata.org/w/api.php','',0,0),('wikif1','http://www.wikif1.org/$1','','',0,0),('wikihow','http://www.wikihow.com/$1','http://www.wikihow.com/api.php','',0,0),('wikimedia','https://wikimediafoundation.org/wiki/$1','https://wikimediafoundation.org/w/api.php','',0,0),('wikinews','https://en.wikinews.org/wiki/$1','https://en.wikinews.org/w/api.php','',0,0),('wikinfo','http://wikinfo.co/English/index.php/$1','','',0,0),('wikipedia','https://en.wikipedia.org/wiki/$1','https://en.wikipedia.org/w/api.php','',0,0),('wikiquote','https://en.wikiquote.org/wiki/$1','https://en.wikiquote.org/w/api.php','',0,0),('wikisource','https://wikisource.org/wiki/$1','https://wikisource.org/w/api.php','',0,0),('wikispecies','https://species.wikimedia.org/wiki/$1','https://species.wikimedia.org/w/api.php','',0,0),('wikiversity','https://en.wikiversity.org/wiki/$1','https://en.wikiversity.org/w/api.php','',0,0),('wikivoyage','https://en.wikivoyage.org/wiki/$1','https://en.wikivoyage.org/w/api.php','',0,0),('wikt','https://en.wiktionary.org/wiki/$1','https://en.wiktionary.org/w/api.php','',0,0),('wiktionary','https://en.wiktionary.org/wiki/$1','https://en.wiktionary.org/w/api.php','',0,0);
/*!40000 ALTER TABLE `interwiki` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_changes`
--

DROP TABLE IF EXISTS `ip_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_changes` (
  `ipc_rev_id` int(10) unsigned NOT NULL DEFAULT '0',
  `ipc_rev_timestamp` binary(14) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `ipc_hex` varbinary(35) NOT NULL DEFAULT '',
  PRIMARY KEY (`ipc_rev_id`),
  KEY `ipc_rev_timestamp` (`ipc_rev_timestamp`),
  KEY `ipc_hex_time` (`ipc_hex`,`ipc_rev_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_changes`
--

LOCK TABLES `ip_changes` WRITE;
/*!40000 ALTER TABLE `ip_changes` DISABLE KEYS */;
INSERT INTO `ip_changes` VALUES (2,'20171205190616','7F000001'),(3,'20171205190616','7F000001'),(4,'20171205190616','7F000001'),(5,'20171205190617','7F000001'),(6,'20171205190617','7F000001'),(7,'20171205190617','7F000001'),(8,'20171205190617','7F000001');
/*!40000 ALTER TABLE `ip_changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipblocks`
--

DROP TABLE IF EXISTS `ipblocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipblocks` (
  `ipb_id` int(11) NOT NULL AUTO_INCREMENT,
  `ipb_address` tinyblob NOT NULL,
  `ipb_user` int(10) unsigned NOT NULL DEFAULT '0',
  `ipb_by` int(10) unsigned NOT NULL DEFAULT '0',
  `ipb_by_text` varbinary(255) NOT NULL DEFAULT '',
  `ipb_reason` varbinary(767) NOT NULL DEFAULT '',
  `ipb_reason_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `ipb_timestamp` binary(14) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `ipb_auto` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_anon_only` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_create_account` tinyint(1) NOT NULL DEFAULT '1',
  `ipb_enable_autoblock` tinyint(1) NOT NULL DEFAULT '1',
  `ipb_expiry` varbinary(14) NOT NULL DEFAULT '',
  `ipb_range_start` tinyblob NOT NULL,
  `ipb_range_end` tinyblob NOT NULL,
  `ipb_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_block_email` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_allow_usertalk` tinyint(1) NOT NULL DEFAULT '0',
  `ipb_parent_block_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`ipb_id`),
  UNIQUE KEY `ipb_address` (`ipb_address`(255),`ipb_user`,`ipb_auto`,`ipb_anon_only`),
  KEY `ipb_user` (`ipb_user`),
  KEY `ipb_range` (`ipb_range_start`(8),`ipb_range_end`(8)),
  KEY `ipb_timestamp` (`ipb_timestamp`),
  KEY `ipb_expiry` (`ipb_expiry`),
  KEY `ipb_parent_block_id` (`ipb_parent_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipblocks`
--

LOCK TABLES `ipblocks` WRITE;
/*!40000 ALTER TABLE `ipblocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `ipblocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iwlinks`
--

DROP TABLE IF EXISTS `iwlinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iwlinks` (
  `iwl_from` int(10) unsigned NOT NULL DEFAULT '0',
  `iwl_prefix` varbinary(20) NOT NULL DEFAULT '',
  `iwl_title` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`iwl_from`,`iwl_prefix`,`iwl_title`),
  KEY `iwl_prefix_title_from` (`iwl_prefix`,`iwl_title`,`iwl_from`),
  KEY `iwl_prefix_from_title` (`iwl_prefix`,`iwl_from`,`iwl_title`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iwlinks`
--

LOCK TABLES `iwlinks` WRITE;
/*!40000 ALTER TABLE `iwlinks` DISABLE KEYS */;
/*!40000 ALTER TABLE `iwlinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job` (
  `job_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job_cmd` varbinary(60) NOT NULL DEFAULT '',
  `job_namespace` int(11) NOT NULL,
  `job_title` varbinary(255) NOT NULL,
  `job_timestamp` varbinary(14) DEFAULT NULL,
  `job_params` blob NOT NULL,
  `job_random` int(10) unsigned NOT NULL DEFAULT '0',
  `job_attempts` int(10) unsigned NOT NULL DEFAULT '0',
  `job_token` varbinary(32) NOT NULL DEFAULT '',
  `job_token_timestamp` varbinary(14) DEFAULT NULL,
  `job_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`job_id`),
  KEY `job_sha1` (`job_sha1`),
  KEY `job_cmd_token` (`job_cmd`,`job_token`,`job_random`),
  KEY `job_cmd_token_id` (`job_cmd`,`job_token`,`job_id`),
  KEY `job_cmd` (`job_cmd`,`job_namespace`,`job_title`,`job_params`(128)),
  KEY `job_timestamp` (`job_timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job`
--

LOCK TABLES `job` WRITE;
/*!40000 ALTER TABLE `job` DISABLE KEYS */;
/*!40000 ALTER TABLE `job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `l10n_cache`
--

DROP TABLE IF EXISTS `l10n_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `l10n_cache` (
  `lc_lang` varbinary(32) NOT NULL,
  `lc_key` varbinary(255) NOT NULL,
  `lc_value` mediumblob NOT NULL,
  PRIMARY KEY (`lc_lang`,`lc_key`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `l10n_cache`
--

LOCK TABLES `l10n_cache` WRITE;
/*!40000 ALTER TABLE `l10n_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `l10n_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `langlinks`
--

DROP TABLE IF EXISTS `langlinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `langlinks` (
  `ll_from` int(10) unsigned NOT NULL DEFAULT '0',
  `ll_lang` varbinary(20) NOT NULL DEFAULT '',
  `ll_title` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ll_from`,`ll_lang`),
  KEY `ll_lang` (`ll_lang`,`ll_title`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `langlinks`
--

LOCK TABLES `langlinks` WRITE;
/*!40000 ALTER TABLE `langlinks` DISABLE KEYS */;
/*!40000 ALTER TABLE `langlinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_search`
--

DROP TABLE IF EXISTS `log_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_search` (
  `ls_field` varbinary(32) NOT NULL,
  `ls_value` varbinary(255) NOT NULL,
  `ls_log_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ls_field`,`ls_value`,`ls_log_id`),
  KEY `ls_log_id` (`ls_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_search`
--

LOCK TABLES `log_search` WRITE;
/*!40000 ALTER TABLE `log_search` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_search` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logging`
--

DROP TABLE IF EXISTS `logging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logging` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_type` varbinary(32) NOT NULL DEFAULT '',
  `log_action` varbinary(32) NOT NULL DEFAULT '',
  `log_timestamp` binary(14) NOT NULL DEFAULT '19700101000000',
  `log_user` int(10) unsigned NOT NULL DEFAULT '0',
  `log_user_text` varbinary(255) NOT NULL DEFAULT '',
  `log_namespace` int(11) NOT NULL DEFAULT '0',
  `log_title` varbinary(255) NOT NULL DEFAULT '',
  `log_page` int(10) unsigned DEFAULT NULL,
  `log_comment` varbinary(767) NOT NULL DEFAULT '',
  `log_comment_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `log_params` blob NOT NULL,
  `log_deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`log_id`),
  KEY `type_time` (`log_type`,`log_timestamp`),
  KEY `user_time` (`log_user`,`log_timestamp`),
  KEY `page_time` (`log_namespace`,`log_title`,`log_timestamp`),
  KEY `times` (`log_timestamp`),
  KEY `log_user_type_time` (`log_user`,`log_type`,`log_timestamp`),
  KEY `log_page_id_time` (`log_page`,`log_timestamp`),
  KEY `type_action` (`log_type`,`log_action`,`log_timestamp`),
  KEY `log_user_text_type_time` (`log_user_text`,`log_type`,`log_timestamp`),
  KEY `log_user_text_time` (`log_user_text`,`log_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logging`
--

LOCK TABLES `logging` WRITE;
/*!40000 ALTER TABLE `logging` DISABLE KEYS */;
/*!40000 ALTER TABLE `logging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_deps`
--

DROP TABLE IF EXISTS `module_deps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `module_deps` (
  `md_module` varbinary(255) NOT NULL,
  `md_skin` varbinary(32) NOT NULL,
  `md_deps` mediumblob NOT NULL,
  PRIMARY KEY (`md_module`,`md_skin`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_deps`
--

LOCK TABLES `module_deps` WRITE;
/*!40000 ALTER TABLE `module_deps` DISABLE KEYS */;
/*!40000 ALTER TABLE `module_deps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objectcache`
--

DROP TABLE IF EXISTS `objectcache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objectcache` (
  `keyname` varbinary(255) NOT NULL DEFAULT '',
  `value` mediumblob,
  `exptime` datetime DEFAULT NULL,
  PRIMARY KEY (`keyname`),
  KEY `exptime` (`exptime`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectcache`
--

LOCK TABLES `objectcache` WRITE;
/*!40000 ALTER TABLE `objectcache` DISABLE KEYS */;
/*!40000 ALTER TABLE `objectcache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oldimage`
--

DROP TABLE IF EXISTS `oldimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oldimage` (
  `oi_name` varbinary(255) NOT NULL DEFAULT '',
  `oi_archive_name` varbinary(255) NOT NULL DEFAULT '',
  `oi_size` int(10) unsigned NOT NULL DEFAULT '0',
  `oi_width` int(11) NOT NULL DEFAULT '0',
  `oi_height` int(11) NOT NULL DEFAULT '0',
  `oi_bits` int(11) NOT NULL DEFAULT '0',
  `oi_description` varbinary(767) NOT NULL DEFAULT '',
  `oi_description_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `oi_user` int(10) unsigned NOT NULL DEFAULT '0',
  `oi_user_text` varbinary(255) NOT NULL,
  `oi_timestamp` binary(14) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `oi_metadata` mediumblob NOT NULL,
  `oi_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `oi_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') NOT NULL DEFAULT 'unknown',
  `oi_minor_mime` varbinary(100) NOT NULL DEFAULT 'unknown',
  `oi_deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `oi_sha1` varbinary(32) NOT NULL DEFAULT '',
  KEY `oi_usertext_timestamp` (`oi_user_text`,`oi_timestamp`),
  KEY `oi_name_timestamp` (`oi_name`,`oi_timestamp`),
  KEY `oi_name_archive_name` (`oi_name`,`oi_archive_name`(14)),
  KEY `oi_sha1` (`oi_sha1`(10))
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oldimage`
--

LOCK TABLES `oldimage` WRITE;
/*!40000 ALTER TABLE `oldimage` DISABLE KEYS */;
/*!40000 ALTER TABLE `oldimage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page`
--

DROP TABLE IF EXISTS `page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page` (
  `page_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `page_namespace` int(11) NOT NULL,
  `page_title` varbinary(255) NOT NULL,
  `page_restrictions` tinyblob NOT NULL,
  `page_is_redirect` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `page_is_new` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `page_random` double unsigned NOT NULL,
  `page_touched` binary(14) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `page_links_updated` varbinary(14) DEFAULT NULL,
  `page_latest` int(10) unsigned NOT NULL,
  `page_len` int(10) unsigned NOT NULL,
  `page_content_model` varbinary(32) DEFAULT NULL,
  `page_lang` varbinary(35) DEFAULT NULL,
  PRIMARY KEY (`page_id`),
  UNIQUE KEY `name_title` (`page_namespace`,`page_title`),
  KEY `page_random` (`page_random`),
  KEY `page_len` (`page_len`),
  KEY `page_redirect_namespace_len` (`page_is_redirect`,`page_namespace`,`page_len`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page`
--

LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES (1,0,'Main_Page','',0,1,0.054348610366,'20171205190153',NULL,1,735,'wikitext',NULL),(2,8,'Smw_import_skos','',0,1,0.547495355599,'20171205190616','20171205190616',2,982,'wikitext',NULL),(3,8,'Smw_import_foaf','',0,1,0.361031790793,'20171205190616','20171205190616',3,298,'wikitext',NULL),(4,8,'Smw_import_owl','',0,1,0.821401768461,'20171205190617','20171205190616',4,1196,'wikitext',NULL),(5,102,'Foaf:knows','',0,1,0.716244138601,'20171205190617','20171205190617',5,233,'wikitext',NULL),(6,102,'Foaf:name','',0,1,0.938874437682,'20171205190617','20171205190617',6,159,'wikitext',NULL),(7,102,'Foaf:homepage','',0,1,0.017014048072,'20171205190617','20171205190617',7,203,'wikitext',NULL),(8,102,'Owl:differentFrom','',0,1,0.670590120344,'20171205190617','20171205190617',8,215,'wikitext',NULL),(9,10,'Flow-maininta','',0,1,0.251525772749,'20171205190618','20171205190618',9,56,'wikitext',NULL),(10,10,'LQT_siirsi_ketjutyngän,_joka_oli_muunnettu_Flow\'hun','',0,1,0.638389827414,'20171205190618','20171205190618',10,86,'wikitext',NULL),(11,10,'Flow\'hun_muunnettu_LQT-sivu','',0,1,0.137894884219,'20171205190618','20171205190618',11,149,'wikitext',NULL),(12,10,'Muunnetun_LQT-sivun_arkisto','',0,1,0.746349929212,'20171205190618','20171205190618',12,179,'wikitext',NULL),(13,10,'LQT-viesti_siirrettiin_häivytetyn_käyttäjän_kanssa','',0,1,0.170405185287,'20171205190618','20171205190618',13,113,'wikitext',NULL),(14,10,'LQT_post_imported_with_different_signature_user','',0,1,0.322290242241,'20171205190618','20171205190618',14,140,'wikitext',NULL),(15,10,'Flow\'hun_muunnettu_wikitekstikeskustelusivu','',0,1,0.00067016304,'20171205190618','20171205190618',15,127,'wikitext',NULL),(16,10,'Muunnetun_wikitekstikeskustelusivun_arkisto','',0,1,0.630299058694,'20171205190618','20171205190618',16,185,'wikitext',NULL);
/*!40000 ALTER TABLE `page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_props`
--

DROP TABLE IF EXISTS `page_props`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_props` (
  `pp_page` int(11) NOT NULL,
  `pp_propname` varbinary(60) NOT NULL,
  `pp_value` blob NOT NULL,
  `pp_sortkey` float DEFAULT NULL,
  UNIQUE KEY `pp_page_propname` (`pp_page`,`pp_propname`),
  UNIQUE KEY `pp_propname_page` (`pp_propname`,`pp_page`),
  UNIQUE KEY `pp_propname_sortkey_page` (`pp_propname`,`pp_sortkey`,`pp_page`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_props`
--

LOCK TABLES `page_props` WRITE;
/*!40000 ALTER TABLE `page_props` DISABLE KEYS */;
INSERT INTO `page_props` VALUES (2,'smw-semanticdata-status','1',1),(3,'smw-semanticdata-status','1',1),(4,'smw-semanticdata-status','1',1),(5,'displaytitle','foaf:knows',NULL),(5,'smw-semanticdata-status','1',1),(6,'displaytitle','foaf:name',NULL),(6,'smw-semanticdata-status','1',1),(7,'displaytitle','foaf:homepage',NULL),(7,'smw-semanticdata-status','1',1),(8,'displaytitle','owl:differentFrom',NULL),(8,'smw-semanticdata-status','1',1),(9,'smw-semanticdata-status','1',1),(10,'smw-semanticdata-status','1',1),(11,'smw-semanticdata-status','1',1),(12,'smw-semanticdata-status','1',1),(13,'smw-semanticdata-status','1',1),(14,'smw-semanticdata-status','1',1),(15,'smw-semanticdata-status','1',1),(16,'smw-semanticdata-status','1',1);
/*!40000 ALTER TABLE `page_props` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_restrictions`
--

DROP TABLE IF EXISTS `page_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_restrictions` (
  `pr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pr_page` int(11) NOT NULL,
  `pr_type` varbinary(60) NOT NULL,
  `pr_level` varbinary(60) NOT NULL,
  `pr_cascade` tinyint(4) NOT NULL,
  `pr_user` int(10) unsigned DEFAULT NULL,
  `pr_expiry` varbinary(14) DEFAULT NULL,
  PRIMARY KEY (`pr_id`),
  UNIQUE KEY `pr_pagetype` (`pr_page`,`pr_type`),
  KEY `pr_typelevel` (`pr_type`,`pr_level`),
  KEY `pr_level` (`pr_level`),
  KEY `pr_cascade` (`pr_cascade`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_restrictions`
--

LOCK TABLES `page_restrictions` WRITE;
/*!40000 ALTER TABLE `page_restrictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `page_restrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagelinks`
--

DROP TABLE IF EXISTS `pagelinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagelinks` (
  `pl_from` int(10) unsigned NOT NULL DEFAULT '0',
  `pl_from_namespace` int(11) NOT NULL DEFAULT '0',
  `pl_namespace` int(11) NOT NULL DEFAULT '0',
  `pl_title` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`pl_from`,`pl_namespace`,`pl_title`),
  KEY `pl_namespace` (`pl_namespace`,`pl_title`,`pl_from`),
  KEY `pl_backlinks_namespace` (`pl_from_namespace`,`pl_namespace`,`pl_title`,`pl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagelinks`
--

LOCK TABLES `pagelinks` WRITE;
/*!40000 ALTER TABLE `pagelinks` DISABLE KEYS */;
INSERT INTO `pagelinks` VALUES (9,10,2,'Example'),(16,10,11,'Muunnetun_wikitekstikeskustelusivun_arkisto'),(5,102,8,'Smw_import_foaf'),(6,102,8,'Smw_import_foaf'),(7,102,8,'Smw_import_foaf'),(8,102,8,'Smw_import_owl');
/*!40000 ALTER TABLE `pagelinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `protected_titles`
--

DROP TABLE IF EXISTS `protected_titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protected_titles` (
  `pt_namespace` int(11) NOT NULL,
  `pt_title` varbinary(255) NOT NULL,
  `pt_user` int(10) unsigned NOT NULL,
  `pt_reason` varbinary(767) DEFAULT '',
  `pt_reason_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `pt_timestamp` binary(14) NOT NULL,
  `pt_expiry` varbinary(14) NOT NULL DEFAULT '',
  `pt_create_perm` varbinary(60) NOT NULL,
  UNIQUE KEY `pt_namespace_title` (`pt_namespace`,`pt_title`),
  KEY `pt_timestamp` (`pt_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `protected_titles`
--

LOCK TABLES `protected_titles` WRITE;
/*!40000 ALTER TABLE `protected_titles` DISABLE KEYS */;
/*!40000 ALTER TABLE `protected_titles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `querycache`
--

DROP TABLE IF EXISTS `querycache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `querycache` (
  `qc_type` varbinary(32) NOT NULL,
  `qc_value` int(10) unsigned NOT NULL DEFAULT '0',
  `qc_namespace` int(11) NOT NULL DEFAULT '0',
  `qc_title` varbinary(255) NOT NULL DEFAULT '',
  KEY `qc_type` (`qc_type`,`qc_value`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `querycache`
--

LOCK TABLES `querycache` WRITE;
/*!40000 ALTER TABLE `querycache` DISABLE KEYS */;
/*!40000 ALTER TABLE `querycache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `querycache_info`
--

DROP TABLE IF EXISTS `querycache_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `querycache_info` (
  `qci_type` varbinary(32) NOT NULL DEFAULT '',
  `qci_timestamp` binary(14) NOT NULL DEFAULT '19700101000000',
  PRIMARY KEY (`qci_type`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `querycache_info`
--

LOCK TABLES `querycache_info` WRITE;
/*!40000 ALTER TABLE `querycache_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `querycache_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `querycachetwo`
--

DROP TABLE IF EXISTS `querycachetwo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `querycachetwo` (
  `qcc_type` varbinary(32) NOT NULL,
  `qcc_value` int(10) unsigned NOT NULL DEFAULT '0',
  `qcc_namespace` int(11) NOT NULL DEFAULT '0',
  `qcc_title` varbinary(255) NOT NULL DEFAULT '',
  `qcc_namespacetwo` int(11) NOT NULL DEFAULT '0',
  `qcc_titletwo` varbinary(255) NOT NULL DEFAULT '',
  KEY `qcc_type` (`qcc_type`,`qcc_value`),
  KEY `qcc_title` (`qcc_type`,`qcc_namespace`,`qcc_title`),
  KEY `qcc_titletwo` (`qcc_type`,`qcc_namespacetwo`,`qcc_titletwo`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `querycachetwo`
--

LOCK TABLES `querycachetwo` WRITE;
/*!40000 ALTER TABLE `querycachetwo` DISABLE KEYS */;
/*!40000 ALTER TABLE `querycachetwo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recentchanges`
--

DROP TABLE IF EXISTS `recentchanges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recentchanges` (
  `rc_id` int(11) NOT NULL AUTO_INCREMENT,
  `rc_timestamp` varbinary(14) NOT NULL DEFAULT '',
  `rc_user` int(10) unsigned NOT NULL DEFAULT '0',
  `rc_user_text` varbinary(255) NOT NULL,
  `rc_namespace` int(11) NOT NULL DEFAULT '0',
  `rc_title` varbinary(255) NOT NULL DEFAULT '',
  `rc_comment` varbinary(767) NOT NULL DEFAULT '',
  `rc_comment_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `rc_minor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rc_bot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rc_new` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rc_cur_id` int(10) unsigned NOT NULL DEFAULT '0',
  `rc_this_oldid` int(10) unsigned NOT NULL DEFAULT '0',
  `rc_last_oldid` int(10) unsigned NOT NULL DEFAULT '0',
  `rc_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rc_source` varbinary(16) NOT NULL DEFAULT '',
  `rc_patrolled` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rc_ip` varbinary(40) NOT NULL DEFAULT '',
  `rc_old_len` int(11) DEFAULT NULL,
  `rc_new_len` int(11) DEFAULT NULL,
  `rc_deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rc_logid` int(10) unsigned NOT NULL DEFAULT '0',
  `rc_log_type` varbinary(255) DEFAULT NULL,
  `rc_log_action` varbinary(255) DEFAULT NULL,
  `rc_params` blob,
  PRIMARY KEY (`rc_id`),
  KEY `rc_timestamp` (`rc_timestamp`),
  KEY `rc_namespace_title` (`rc_namespace`,`rc_title`),
  KEY `rc_cur_id` (`rc_cur_id`),
  KEY `new_name_timestamp` (`rc_new`,`rc_namespace`,`rc_timestamp`),
  KEY `rc_ip` (`rc_ip`),
  KEY `rc_ns_usertext` (`rc_namespace`,`rc_user_text`),
  KEY `rc_user_text` (`rc_user_text`,`rc_timestamp`),
  KEY `rc_name_type_patrolled_timestamp` (`rc_namespace`,`rc_type`,`rc_patrolled`,`rc_timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recentchanges`
--

LOCK TABLES `recentchanges` WRITE;
/*!40000 ALTER TABLE `recentchanges` DISABLE KEYS */;
INSERT INTO `recentchanges` VALUES (1,'20171205190153',0,'MediaWiki default',0,'Main_Page','',0,0,0,1,1,1,0,1,'mw.new',0,'127.0.0.1',0,735,0,0,NULL,'',''),(2,'20171205190616',0,'127.0.0.1',8,'Smw_import_skos','Semantic MediaWiki default vocabulary import',0,0,1,1,2,2,0,1,'mw.new',0,'127.0.0.1',0,982,0,0,NULL,'',''),(3,'20171205190616',0,'127.0.0.1',8,'Smw_import_foaf','Semantic MediaWiki default vocabulary import',0,0,1,1,3,3,0,1,'mw.new',0,'127.0.0.1',0,298,0,0,NULL,'',''),(4,'20171205190616',0,'127.0.0.1',8,'Smw_import_owl','Semantic MediaWiki default vocabulary import',0,0,1,1,4,4,0,1,'mw.new',0,'127.0.0.1',0,1196,0,0,NULL,'',''),(5,'20171205190617',0,'127.0.0.1',102,'Foaf:knows','Semantic MediaWiki default vocabulary import',0,0,1,1,5,5,0,1,'mw.new',0,'127.0.0.1',0,233,0,0,NULL,'',''),(6,'20171205190617',0,'127.0.0.1',102,'Foaf:name','Semantic MediaWiki default vocabulary import',0,0,1,1,6,6,0,1,'mw.new',0,'127.0.0.1',0,159,0,0,NULL,'',''),(7,'20171205190617',0,'127.0.0.1',102,'Foaf:homepage','Semantic MediaWiki default vocabulary import',0,0,1,1,7,7,0,1,'mw.new',0,'127.0.0.1',0,203,0,0,NULL,'',''),(8,'20171205190617',0,'127.0.0.1',102,'Owl:differentFrom','Semantic MediaWiki default vocabulary import',0,0,1,1,8,8,0,1,'mw.new',0,'127.0.0.1',0,215,0,0,NULL,'','');
/*!40000 ALTER TABLE `recentchanges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `redirect`
--

DROP TABLE IF EXISTS `redirect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `redirect` (
  `rd_from` int(10) unsigned NOT NULL DEFAULT '0',
  `rd_namespace` int(11) NOT NULL DEFAULT '0',
  `rd_title` varbinary(255) NOT NULL DEFAULT '',
  `rd_interwiki` varbinary(32) DEFAULT NULL,
  `rd_fragment` varbinary(255) DEFAULT NULL,
  PRIMARY KEY (`rd_from`),
  KEY `rd_ns_title` (`rd_namespace`,`rd_title`,`rd_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `redirect`
--

LOCK TABLES `redirect` WRITE;
/*!40000 ALTER TABLE `redirect` DISABLE KEYS */;
/*!40000 ALTER TABLE `redirect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `revision`
--

DROP TABLE IF EXISTS `revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `revision` (
  `rev_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rev_page` int(10) unsigned NOT NULL,
  `rev_text_id` int(10) unsigned NOT NULL,
  `rev_comment` varbinary(767) NOT NULL DEFAULT '',
  `rev_user` int(10) unsigned NOT NULL DEFAULT '0',
  `rev_user_text` varbinary(255) NOT NULL DEFAULT '',
  `rev_timestamp` binary(14) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `rev_minor_edit` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rev_deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rev_len` int(10) unsigned DEFAULT NULL,
  `rev_parent_id` int(10) unsigned DEFAULT NULL,
  `rev_sha1` varbinary(32) NOT NULL DEFAULT '',
  `rev_content_model` varbinary(32) DEFAULT NULL,
  `rev_content_format` varbinary(64) DEFAULT NULL,
  PRIMARY KEY (`rev_id`),
  KEY `rev_page_id` (`rev_page`,`rev_id`),
  KEY `rev_timestamp` (`rev_timestamp`),
  KEY `page_timestamp` (`rev_page`,`rev_timestamp`),
  KEY `user_timestamp` (`rev_user`,`rev_timestamp`),
  KEY `usertext_timestamp` (`rev_user_text`,`rev_timestamp`),
  KEY `page_user_timestamp` (`rev_page`,`rev_user`,`rev_timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=binary MAX_ROWS=10000000 AVG_ROW_LENGTH=1024;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `revision`
--

LOCK TABLES `revision` WRITE;
/*!40000 ALTER TABLE `revision` DISABLE KEYS */;
INSERT INTO `revision` VALUES (1,1,1,'',0,'MediaWiki default','20171205190153',0,0,735,0,'a5wehuldd0go2uniagwvx66n6c80irq',NULL,NULL),(2,2,2,'Semantic MediaWiki default vocabulary import',0,'127.0.0.1','20171205190616',0,0,982,0,'7uej7l6j7zibffqxeqr83oypfu8tya3',NULL,NULL),(3,3,3,'Semantic MediaWiki default vocabulary import',0,'127.0.0.1','20171205190616',0,0,298,0,'54j1f1u0gxrlqu4877gsk6vv72gs354',NULL,NULL),(4,4,4,'Semantic MediaWiki default vocabulary import',0,'127.0.0.1','20171205190616',0,0,1196,0,'mjrj8ysg8aclt8sddeabn26vvadmsuy',NULL,NULL),(5,5,5,'Semantic MediaWiki default vocabulary import',0,'127.0.0.1','20171205190617',0,0,233,0,'5fpdmhtk9h4opuere6cb7zrdzeal6ur',NULL,NULL),(6,6,6,'Semantic MediaWiki default vocabulary import',0,'127.0.0.1','20171205190617',0,0,159,0,'ncohsxx9qrs0wyig0kjyyumifnyz4sk',NULL,NULL),(7,7,7,'Semantic MediaWiki default vocabulary import',0,'127.0.0.1','20171205190617',0,0,203,0,'2ywqz2j0v9tvaqdlu13mz1xmen6dm2z',NULL,NULL),(8,8,8,'Semantic MediaWiki default vocabulary import',0,'127.0.0.1','20171205190617',0,0,215,0,'39ysbnyduz283si6e9m8qbpfxrlehcl',NULL,NULL),(9,9,9,'/* Automatically created by Flow */',2,'Flow talk page manager','20171205190618',0,0,56,0,'s9v9cld4trshzizfhz30xrx1nkd9e8j',NULL,NULL),(10,10,10,'/* Automatically created by Flow */',2,'Flow talk page manager','20171205190618',0,0,86,0,'e5j16chw2130kmdotptl65jvxa6lw5w',NULL,NULL),(11,11,11,'/* Automatically created by Flow */',2,'Flow talk page manager','20171205190618',0,0,149,0,'njhr9sbh7lx81p2xfwikn7amdd3n1zn',NULL,NULL),(12,12,12,'/* Automatically created by Flow */',2,'Flow talk page manager','20171205190618',0,0,179,0,'czc7i63hlfrg2e5xeq3jxbll1jaqi60',NULL,NULL),(13,13,13,'/* Automatically created by Flow */',2,'Flow talk page manager','20171205190618',0,0,113,0,'1pswkbcu7hauadd98nklgf3pku080ee',NULL,NULL),(14,14,14,'/* Automatically created by Flow */',2,'Flow talk page manager','20171205190618',0,0,140,0,'0ipb21k90lnswxlie8k6fzj4xrskdyk',NULL,NULL),(15,15,15,'/* Automatically created by Flow */',2,'Flow talk page manager','20171205190618',0,0,127,0,'ccusakfp9y2sl227h5sbt4ok1ptcsxi',NULL,NULL),(16,16,16,'/* Automatically created by Flow */',2,'Flow talk page manager','20171205190618',0,0,185,0,'p6f92qo09y807ag8jjw6iw7trwykdkw',NULL,NULL);
/*!40000 ALTER TABLE `revision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `revision_comment_temp`
--

DROP TABLE IF EXISTS `revision_comment_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `revision_comment_temp` (
  `revcomment_rev` int(10) unsigned NOT NULL,
  `revcomment_comment_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`revcomment_rev`,`revcomment_comment_id`),
  UNIQUE KEY `revcomment_rev` (`revcomment_rev`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `revision_comment_temp`
--

LOCK TABLES `revision_comment_temp` WRITE;
/*!40000 ALTER TABLE `revision_comment_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `revision_comment_temp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `searchindex`
--

DROP TABLE IF EXISTS `searchindex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `searchindex` (
  `si_page` int(10) unsigned NOT NULL,
  `si_title` varchar(255) NOT NULL DEFAULT '',
  `si_text` mediumtext NOT NULL,
  UNIQUE KEY `si_page` (`si_page`),
  FULLTEXT KEY `si_title` (`si_title`),
  FULLTEXT KEY `si_text` (`si_text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `searchindex`
--

LOCK TABLES `searchindex` WRITE;
/*!40000 ALTER TABLE `searchindex` DISABLE KEYS */;
INSERT INTO `searchindex` VALUES (2,'smwu800 import skos',' simple knowledge organization system skos altlabel type monolingual text broader type annotation uriu800 broadertransitive type annotation uriu800 broadmatch type annotation uriu800 changenote type text closematch type annotation uriu800 collection class concept class conceptscheme class definition type text editorialnote type text exactmatch type annotation uriu800 example type text hastopconcept type page hiddenlabel type string historynote type text inscheme type page mappingrelation type page member type page memberlist type page narrower type annotation uriu800 narrowertransitive type annotation uriu800 narrowmatch type annotation uriu800 notation type text note type text orderedcollection class preflabel type string related type annotation uriu800 relatedmatch type annotation uriu800 scopenote type text semanticrelation type page topconceptof type page category imported vocabulary '),(3,'smwu800 import foaf',' friend ofu800 au800 friend name type text homepage type urlu800 mbox type email mbox_sha1sum type text depiction type urlu800 phone type text person category organization category knows type page member type page category imported vocabulary '),(4,'smwu800 import owlu800',' webu800 ontology language owlu800 alldifferent category allvaluesfrom type page annotationproperty category backwardcompatiblewith type page cardinality type number class category comment type page complementof type page datarange category datatypeproperty category deprecatedclass category deprecatedproperty category differentfrom type page disjointwith type page distinctmembers type page equivalentclass type page equivalentproperty type page functionalproperty category hasvalue type page imports type page incompatiblewith type page intersectionof type page inversefunctionalproperty category inverseof type page isdefinedby type page label type page maxcardinality type number mincardinality type number nothing category objectproperty category oneof type page onproperty type page ontology category ontologyproperty category owlu800 type page priorversion type page restriction category sameas type page seealso type page somevaluesfrom type page symmetricproperty category thing category transitiveproperty category unionof type page versioninfo type page category imported vocabulary '),(5,'foaf knows',' * imported from foaf knows * hasu800 property description au800 person known byu800 this person indicating some level ofu800 reciprocated interaction between theu800 parties . enu800 category imported vocabulary displaytitle foaf knows '),(6,'foaf name',' * imported from foaf name * hasu800 property description au800 name foru800 some thing oru800 agent. enu800 category imported vocabulary displaytitle foaf name '),(7,'foaf homepage',' * imported from foaf homepage * hasu800 property description urlu800 ofu800 theu800 homepage ofu800 something which isu800 au800 general webu800 resource. enu800 category imported vocabulary displaytitle foaf homepage '),(8,'owlu800 differentfrom',' * imported from owlu800 differentfrom * hasu800 property description theu800 property that determines that twou800 given individuals areu800 different. enu800 category imported vocabulary displaytitle owlu800 differentfrom '),(9,'flow-maininta',' ku8c3a4yttu8c3a4ju8c3a4 1u800 example 2u800 1u800 example '),(10,'lqtu800 siirsi ketjutyngu8c3a4n joka oliu800 muunnettu flow\'hunu800',' this post byu800 author wasu800 moved onu800 date . youu800 canu800 find itu800 atu800 title . '),(11,'flow\'hunu800 muunnettu lqtu800-sivu',' previous page history wasu800 archived foru800 backup purposes atu800 archive onu800 #time yu800-mu800-du800 date . '),(12,'muunnetun lqtu800-sivun arkisto',' this page isu800 anu800 archived liquidthreads page. dou800 notu800 edit theu800 contents ofu800 this page . please direct anyu800 additional comments tou800 theu800 from current talk page . '),(13,'lqtu800-viesti siirrettiin hu8c3a4ivytetyn ku8c3a4yttu8c3a4ju8c3a4n kanssa',' this revision wasu800 imported from liquidthreads with au800 suppressed user. itu800 hasu800 been reassigned tou800 theu800 current user. '),(14,'lqtu800 post imported with different signature user',' this post wasu800 posted byu800 user authoruser authoruser butu800 signed asu800 user signatureuser signatureuser . '),(15,'flow\'hunu800 muunnettu wikitekstikeskustelusivu',' previous discussion wasu800 archived atu800 archive onu800 #time yu800-mu800-du800 date . '),(16,'muunnetun wikitekstikeskustelusivun arkisto',' tu8c3a4mu8c3a4 sivu onu800 arkisto. u8c3a4lu8c3a4 muokkaa tu8c3a4tu8c3a4 sivua . kaikki uudet kommentit aiheesta kuuluvat from talkspace basepagename nykyiselle keskustelusivulle . ');
/*!40000 ALTER TABLE `searchindex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_identifiers`
--

DROP TABLE IF EXISTS `site_identifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_identifiers` (
  `si_site` int(10) unsigned NOT NULL,
  `si_type` varbinary(32) NOT NULL,
  `si_key` varbinary(32) NOT NULL,
  UNIQUE KEY `site_ids_type` (`si_type`,`si_key`),
  KEY `site_ids_site` (`si_site`),
  KEY `site_ids_key` (`si_key`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_identifiers`
--

LOCK TABLES `site_identifiers` WRITE;
/*!40000 ALTER TABLE `site_identifiers` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_identifiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_stats`
--

DROP TABLE IF EXISTS `site_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_stats` (
  `ss_row_id` int(10) unsigned NOT NULL,
  `ss_total_edits` bigint(20) unsigned DEFAULT '0',
  `ss_good_articles` bigint(20) unsigned DEFAULT '0',
  `ss_total_pages` bigint(20) DEFAULT '-1',
  `ss_users` bigint(20) DEFAULT '-1',
  `ss_active_users` bigint(20) DEFAULT '-1',
  `ss_images` int(11) DEFAULT '0',
  PRIMARY KEY (`ss_row_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_stats`
--

LOCK TABLES `site_stats` WRITE;
/*!40000 ALTER TABLE `site_stats` DISABLE KEYS */;
INSERT INTO `site_stats` VALUES (1,15,0,15,1,0,0);
/*!40000 ALTER TABLE `site_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `site_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `site_global_key` varbinary(32) NOT NULL,
  `site_type` varbinary(32) NOT NULL,
  `site_group` varbinary(32) NOT NULL,
  `site_source` varbinary(32) NOT NULL,
  `site_language` varbinary(32) NOT NULL,
  `site_protocol` varbinary(32) NOT NULL,
  `site_domain` varbinary(255) NOT NULL,
  `site_data` blob NOT NULL,
  `site_forward` tinyint(1) NOT NULL,
  `site_config` blob NOT NULL,
  PRIMARY KEY (`site_id`),
  UNIQUE KEY `sites_global_key` (`site_global_key`),
  KEY `sites_type` (`site_type`),
  KEY `sites_group` (`site_group`),
  KEY `sites_source` (`site_source`),
  KEY `sites_language` (`site_language`),
  KEY `sites_protocol` (`site_protocol`),
  KEY `sites_domain` (`site_domain`),
  KEY `sites_forward` (`site_forward`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_concept_cache`
--

DROP TABLE IF EXISTS `smw_concept_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_concept_cache` (
  `s_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned NOT NULL,
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_concept_cache`
--

LOCK TABLES `smw_concept_cache` WRITE;
/*!40000 ALTER TABLE `smw_concept_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_concept_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_di_blob`
--

DROP TABLE IF EXISTS `smw_di_blob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_di_blob` (
  `s_id` int(8) unsigned NOT NULL,
  `p_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`,`p_id`),
  KEY `p_id` (`p_id`,`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_di_blob`
--

LOCK TABLES `smw_di_blob` WRITE;
/*!40000 ALTER TABLE `smw_di_blob` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_di_blob` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_di_bool`
--

DROP TABLE IF EXISTS `smw_di_bool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_di_bool` (
  `s_id` int(8) unsigned NOT NULL,
  `p_id` int(8) unsigned NOT NULL,
  `o_value` tinyint(1) DEFAULT NULL,
  KEY `s_id` (`s_id`,`p_id`),
  KEY `p_id` (`p_id`,`o_value`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_di_bool`
--

LOCK TABLES `smw_di_bool` WRITE;
/*!40000 ALTER TABLE `smw_di_bool` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_di_bool` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_di_coords`
--

DROP TABLE IF EXISTS `smw_di_coords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_di_coords` (
  `s_id` int(8) unsigned NOT NULL,
  `p_id` int(8) unsigned NOT NULL,
  `o_serialized` varbinary(255) DEFAULT NULL,
  `o_lat` double DEFAULT NULL,
  `o_lon` double DEFAULT NULL,
  KEY `s_id` (`s_id`,`p_id`),
  KEY `p_id` (`p_id`,`o_serialized`),
  KEY `o_lat` (`o_lat`,`o_lon`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_di_coords`
--

LOCK TABLES `smw_di_coords` WRITE;
/*!40000 ALTER TABLE `smw_di_coords` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_di_coords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_di_number`
--

DROP TABLE IF EXISTS `smw_di_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_di_number` (
  `s_id` int(8) unsigned NOT NULL,
  `p_id` int(8) unsigned NOT NULL,
  `o_serialized` varbinary(255) DEFAULT NULL,
  `o_sortkey` double DEFAULT NULL,
  KEY `s_id` (`s_id`,`p_id`),
  KEY `p_id` (`p_id`,`o_sortkey`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_di_number`
--

LOCK TABLES `smw_di_number` WRITE;
/*!40000 ALTER TABLE `smw_di_number` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_di_number` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_di_time`
--

DROP TABLE IF EXISTS `smw_di_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_di_time` (
  `s_id` int(8) unsigned NOT NULL,
  `p_id` int(8) unsigned NOT NULL,
  `o_serialized` varbinary(255) DEFAULT NULL,
  `o_sortkey` double DEFAULT NULL,
  KEY `s_id` (`s_id`,`p_id`),
  KEY `p_id` (`p_id`,`o_sortkey`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_di_time`
--

LOCK TABLES `smw_di_time` WRITE;
/*!40000 ALTER TABLE `smw_di_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_di_time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_di_uri`
--

DROP TABLE IF EXISTS `smw_di_uri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_di_uri` (
  `s_id` int(8) unsigned NOT NULL,
  `p_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_serialized` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`,`p_id`),
  KEY `p_id` (`p_id`,`o_serialized`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_di_uri`
--

LOCK TABLES `smw_di_uri` WRITE;
/*!40000 ALTER TABLE `smw_di_uri` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_di_uri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_di_wikipage`
--

DROP TABLE IF EXISTS `smw_di_wikipage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_di_wikipage` (
  `s_id` int(8) unsigned NOT NULL,
  `p_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned DEFAULT NULL,
  KEY `s_id` (`s_id`,`p_id`),
  KEY `p_id` (`p_id`,`o_id`),
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_di_wikipage`
--

LOCK TABLES `smw_di_wikipage` WRITE;
/*!40000 ALTER TABLE `smw_di_wikipage` DISABLE KEYS */;
INSERT INTO `smw_di_wikipage` VALUES (51,10,53),(54,10,55),(56,10,57),(58,10,59);
/*!40000 ALTER TABLE `smw_di_wikipage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_ask`
--

DROP TABLE IF EXISTS `smw_fpt_ask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_ask` (
  `s_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_ask`
--

LOCK TABLES `smw_fpt_ask` WRITE;
/*!40000 ALTER TABLE `smw_fpt_ask` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_ask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_askde`
--

DROP TABLE IF EXISTS `smw_fpt_askde`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_askde` (
  `s_id` int(8) unsigned NOT NULL,
  `o_serialized` varbinary(255) DEFAULT NULL,
  `o_sortkey` double DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_sortkey` (`o_sortkey`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_askde`
--

LOCK TABLES `smw_fpt_askde` WRITE;
/*!40000 ALTER TABLE `smw_fpt_askde` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_askde` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_askdu`
--

DROP TABLE IF EXISTS `smw_fpt_askdu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_askdu` (
  `s_id` int(8) unsigned NOT NULL,
  `o_serialized` varbinary(255) DEFAULT NULL,
  `o_sortkey` double DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_sortkey` (`o_sortkey`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_askdu`
--

LOCK TABLES `smw_fpt_askdu` WRITE;
/*!40000 ALTER TABLE `smw_fpt_askdu` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_askdu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_askfo`
--

DROP TABLE IF EXISTS `smw_fpt_askfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_askfo` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_askfo`
--

LOCK TABLES `smw_fpt_askfo` WRITE;
/*!40000 ALTER TABLE `smw_fpt_askfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_askfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_askpa`
--

DROP TABLE IF EXISTS `smw_fpt_askpa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_askpa` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_askpa`
--

LOCK TABLES `smw_fpt_askpa` WRITE;
/*!40000 ALTER TABLE `smw_fpt_askpa` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_askpa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_asksi`
--

DROP TABLE IF EXISTS `smw_fpt_asksi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_asksi` (
  `s_id` int(8) unsigned NOT NULL,
  `o_serialized` varbinary(255) DEFAULT NULL,
  `o_sortkey` double DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_sortkey` (`o_sortkey`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_asksi`
--

LOCK TABLES `smw_fpt_asksi` WRITE;
/*!40000 ALTER TABLE `smw_fpt_asksi` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_asksi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_askst`
--

DROP TABLE IF EXISTS `smw_fpt_askst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_askst` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_askst`
--

LOCK TABLES `smw_fpt_askst` WRITE;
/*!40000 ALTER TABLE `smw_fpt_askst` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_askst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_conc`
--

DROP TABLE IF EXISTS `smw_fpt_conc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_conc` (
  `s_id` int(8) unsigned NOT NULL,
  `concept_txt` mediumblob,
  `concept_docu` mediumblob,
  `concept_features` int(11) DEFAULT NULL,
  `concept_size` int(11) DEFAULT NULL,
  `concept_depth` int(11) DEFAULT NULL,
  `cache_date` int(8) unsigned DEFAULT NULL,
  `cache_count` int(8) unsigned DEFAULT NULL,
  KEY `s_id` (`s_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_conc`
--

LOCK TABLES `smw_fpt_conc` WRITE;
/*!40000 ALTER TABLE `smw_fpt_conc` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_conc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_conv`
--

DROP TABLE IF EXISTS `smw_fpt_conv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_conv` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_conv`
--

LOCK TABLES `smw_fpt_conv` WRITE;
/*!40000 ALTER TABLE `smw_fpt_conv` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_conv` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_dtitle`
--

DROP TABLE IF EXISTS `smw_fpt_dtitle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_dtitle` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_dtitle`
--

LOCK TABLES `smw_fpt_dtitle` WRITE;
/*!40000 ALTER TABLE `smw_fpt_dtitle` DISABLE KEYS */;
INSERT INTO `smw_fpt_dtitle` VALUES (51,NULL,'foaf:knows'),(54,NULL,'foaf:name'),(56,NULL,'foaf:homepage'),(58,NULL,'owl:differentFrom');
/*!40000 ALTER TABLE `smw_fpt_dtitle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_impo`
--

DROP TABLE IF EXISTS `smw_fpt_impo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_impo` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_impo`
--

LOCK TABLES `smw_fpt_impo` WRITE;
/*!40000 ALTER TABLE `smw_fpt_impo` DISABLE KEYS */;
INSERT INTO `smw_fpt_impo` VALUES (51,NULL,'foaf knows http://xmlns.com/foaf/0.1/ Type:Page'),(54,NULL,'foaf name http://xmlns.com/foaf/0.1/ Type:Text'),(56,NULL,'foaf homepage http://xmlns.com/foaf/0.1/ Type:URL'),(58,NULL,'owl differentFrom http://www.w3.org/2002/07/owl# Type:Page');
/*!40000 ALTER TABLE `smw_fpt_impo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_inst`
--

DROP TABLE IF EXISTS `smw_fpt_inst`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_inst` (
  `s_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_inst`
--

LOCK TABLES `smw_fpt_inst` WRITE;
/*!40000 ALTER TABLE `smw_fpt_inst` DISABLE KEYS */;
INSERT INTO `smw_fpt_inst` VALUES (51,52),(54,52),(56,52),(58,52);
/*!40000 ALTER TABLE `smw_fpt_inst` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_lcode`
--

DROP TABLE IF EXISTS `smw_fpt_lcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_lcode` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_lcode`
--

LOCK TABLES `smw_fpt_lcode` WRITE;
/*!40000 ALTER TABLE `smw_fpt_lcode` DISABLE KEYS */;
INSERT INTO `smw_fpt_lcode` VALUES (53,NULL,'en'),(55,NULL,'en'),(57,NULL,'en'),(59,NULL,'en');
/*!40000 ALTER TABLE `smw_fpt_lcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_list`
--

DROP TABLE IF EXISTS `smw_fpt_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_list` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_list`
--

LOCK TABLES `smw_fpt_list` WRITE;
/*!40000 ALTER TABLE `smw_fpt_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_mdat`
--

DROP TABLE IF EXISTS `smw_fpt_mdat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_mdat` (
  `s_id` int(8) unsigned NOT NULL,
  `o_serialized` varbinary(255) DEFAULT NULL,
  `o_sortkey` double DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_sortkey` (`o_sortkey`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_mdat`
--

LOCK TABLES `smw_fpt_mdat` WRITE;
/*!40000 ALTER TABLE `smw_fpt_mdat` DISABLE KEYS */;
INSERT INTO `smw_fpt_mdat` VALUES (51,'1/2017/12/5/19/6/17/0',2458093.2960301),(54,'1/2017/12/5/19/6/17/0',2458093.2960301),(56,'1/2017/12/5/19/6/17/0',2458093.2960301),(58,'1/2017/12/5/19/6/17/0',2458093.2960301);
/*!40000 ALTER TABLE `smw_fpt_mdat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_pplb`
--

DROP TABLE IF EXISTS `smw_fpt_pplb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_pplb` (
  `s_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_pplb`
--

LOCK TABLES `smw_fpt_pplb` WRITE;
/*!40000 ALTER TABLE `smw_fpt_pplb` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_pplb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_prec`
--

DROP TABLE IF EXISTS `smw_fpt_prec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_prec` (
  `s_id` int(8) unsigned NOT NULL,
  `o_serialized` varbinary(255) DEFAULT NULL,
  `o_sortkey` double DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_sortkey` (`o_sortkey`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_prec`
--

LOCK TABLES `smw_fpt_prec` WRITE;
/*!40000 ALTER TABLE `smw_fpt_prec` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_prec` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_pval`
--

DROP TABLE IF EXISTS `smw_fpt_pval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_pval` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_pval`
--

LOCK TABLES `smw_fpt_pval` WRITE;
/*!40000 ALTER TABLE `smw_fpt_pval` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_pval` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_redi`
--

DROP TABLE IF EXISTS `smw_fpt_redi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_redi` (
  `s_title` varbinary(255) NOT NULL,
  `s_namespace` int(11) NOT NULL,
  `o_id` int(8) unsigned DEFAULT NULL,
  KEY `s_title` (`s_title`,`s_namespace`),
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_redi`
--

LOCK TABLES `smw_fpt_redi` WRITE;
/*!40000 ALTER TABLE `smw_fpt_redi` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_redi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_serv`
--

DROP TABLE IF EXISTS `smw_fpt_serv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_serv` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_serv`
--

LOCK TABLES `smw_fpt_serv` WRITE;
/*!40000 ALTER TABLE `smw_fpt_serv` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_serv` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_sobj`
--

DROP TABLE IF EXISTS `smw_fpt_sobj`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_sobj` (
  `s_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_sobj`
--

LOCK TABLES `smw_fpt_sobj` WRITE;
/*!40000 ALTER TABLE `smw_fpt_sobj` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_sobj` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_subc`
--

DROP TABLE IF EXISTS `smw_fpt_subc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_subc` (
  `s_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_subc`
--

LOCK TABLES `smw_fpt_subc` WRITE;
/*!40000 ALTER TABLE `smw_fpt_subc` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_subc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_subp`
--

DROP TABLE IF EXISTS `smw_fpt_subp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_subp` (
  `s_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_id` (`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_subp`
--

LOCK TABLES `smw_fpt_subp` WRITE;
/*!40000 ALTER TABLE `smw_fpt_subp` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_subp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_text`
--

DROP TABLE IF EXISTS `smw_fpt_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_text` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_text`
--

LOCK TABLES `smw_fpt_text` WRITE;
/*!40000 ALTER TABLE `smw_fpt_text` DISABLE KEYS */;
INSERT INTO `smw_fpt_text` VALUES (53,'A person known by this person (indicating some level of reciprocated interaction between the parties).','A person known by this person (indicatinc500cf2a6bbd104b21343716bb36af52'),(55,NULL,'A name for some thing or agent.'),(57,NULL,'URL of the homepage of something, which is a general web resource.'),(59,NULL,'The property that determines that two given individuals are different.');
/*!40000 ALTER TABLE `smw_fpt_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_type`
--

DROP TABLE IF EXISTS `smw_fpt_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_type` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_serialized` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_serialized` (`o_serialized`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_type`
--

LOCK TABLES `smw_fpt_type` WRITE;
/*!40000 ALTER TABLE `smw_fpt_type` DISABLE KEYS */;
INSERT INTO `smw_fpt_type` VALUES (51,NULL,'http://semantic-mediawiki.org/swivt/1.0#_wpg'),(54,NULL,'http://semantic-mediawiki.org/swivt/1.0#_txt'),(56,NULL,'http://semantic-mediawiki.org/swivt/1.0#_uri'),(58,NULL,'http://semantic-mediawiki.org/swivt/1.0#_wpg');
/*!40000 ALTER TABLE `smw_fpt_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_unit`
--

DROP TABLE IF EXISTS `smw_fpt_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_unit` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_hash` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_hash` (`o_hash`),
  KEY `s_id_2` (`s_id`,`o_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_unit`
--

LOCK TABLES `smw_fpt_unit` WRITE;
/*!40000 ALTER TABLE `smw_fpt_unit` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_fpt_uri`
--

DROP TABLE IF EXISTS `smw_fpt_uri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_fpt_uri` (
  `s_id` int(8) unsigned NOT NULL,
  `o_blob` mediumblob,
  `o_serialized` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_serialized` (`o_serialized`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_fpt_uri`
--

LOCK TABLES `smw_fpt_uri` WRITE;
/*!40000 ALTER TABLE `smw_fpt_uri` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_fpt_uri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_ft_search`
--

DROP TABLE IF EXISTS `smw_ft_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_ft_search` (
  `s_id` int(8) unsigned NOT NULL,
  `p_id` int(8) unsigned NOT NULL,
  `o_text` text,
  `o_sort` varbinary(255) DEFAULT NULL,
  KEY `s_id` (`s_id`),
  KEY `p_id` (`p_id`),
  KEY `o_sort` (`o_sort`),
  FULLTEXT KEY `o_text` (`o_text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_ft_search`
--

LOCK TABLES `smw_ft_search` WRITE;
/*!40000 ALTER TABLE `smw_ft_search` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_ft_search` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_object_ids`
--

DROP TABLE IF EXISTS `smw_object_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_object_ids` (
  `smw_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `smw_namespace` int(11) NOT NULL,
  `smw_title` varbinary(255) NOT NULL,
  `smw_iw` varbinary(32) NOT NULL,
  `smw_subobject` varbinary(255) NOT NULL,
  `smw_sortkey` varbinary(255) NOT NULL,
  `smw_proptable_hash` mediumblob,
  PRIMARY KEY (`smw_id`),
  KEY `smw_id` (`smw_id`,`smw_sortkey`),
  KEY `smw_iw` (`smw_iw`),
  KEY `smw_title` (`smw_title`,`smw_namespace`,`smw_iw`,`smw_subobject`),
  KEY `smw_sortkey` (`smw_sortkey`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_object_ids`
--

LOCK TABLES `smw_object_ids` WRITE;
/*!40000 ALTER TABLE `smw_object_ids` DISABLE KEYS */;
INSERT INTO `smw_object_ids` VALUES (1,102,'_TYPE','','','Has type',NULL),(2,102,'_URI','','','Equivalent URI',NULL),(4,102,'_INST',':smw-intprop','','',NULL),(7,102,'_UNIT','','','Display units',NULL),(8,102,'_IMPO','','','Imported from',NULL),(9,102,'_PPLB','','','Has preferred property label',NULL),(10,102,'_PDESC','','','Has property description',NULL),(11,102,'_PREC','','','Display precision of',NULL),(12,102,'_CONV','','','Corresponds to',NULL),(13,102,'_SERV','','','Provides service',NULL),(14,102,'_PVAL','','','Allows value',NULL),(15,102,'_REDI',':smw-intprop','','',NULL),(16,102,'_DTITLE','','','Display title of',NULL),(17,102,'_SUBP','','','Subproperty of',NULL),(18,102,'_SUBC','','','Subcategory of',NULL),(19,102,'_CONC',':smw-intprop','','',NULL),(22,102,'_ERRP','','','Has improper value for',NULL),(28,102,'_LIST','','','Has fields',NULL),(29,102,'_MDAT','','','Modification date',NULL),(30,102,'_CDAT','','','Creation date',NULL),(31,102,'_NEWP','','','Is a new page',NULL),(32,102,'_LEDT','','','Last editor is',NULL),(33,102,'_ASK','','','Has query',NULL),(34,102,'_ASKST','','','Query string',NULL),(35,102,'_ASKFO','','','Query format',NULL),(36,102,'_ASKSI','','','Query size',NULL),(37,102,'_ASKDE','','','Query depth',NULL),(38,102,'_ASKPA','','','Query parameters',NULL),(39,102,'_ASKSC','','','Query source',NULL),(40,102,'_LCODE','','','Language code',NULL),(41,102,'_TEXT','','','Text',NULL),(50,0,'',':smw-border','','',NULL),(51,102,'Foaf:knows','','','foaf:knows','a:6:{s:15:\"smw_di_wikipage\";s:32:\"9fbc438f7135ad7e99f030e3c3c953cb\";s:12:\"smw_fpt_type\";s:32:\"56e7a9a4d4924f5457f6ac15bf008c50\";s:12:\"smw_fpt_inst\";s:32:\"983cf454de3b4f7565693131fc521c40\";s:12:\"smw_fpt_impo\";s:32:\"625b96cb718bfb58c15313a6be46b45a\";s:14:\"smw_fpt_dtitle\";s:32:\"54bfa764f1d940b95696bf685ebf9800\";s:12:\"smw_fpt_mdat\";s:32:\"03172e4134ffbbb8f9a99ba22da45885\";}'),(52,14,'Imported_vocabulary','','','Imported vocabulary',NULL),(53,102,'Foaf:knows','','_ML5e3514738f61418165c58b589e9d1d11','Foaf:knows#A person known by this person (indicating some level of reciprocated interaction between the parties).;en','a:2:{s:13:\"smw_fpt_lcode\";s:32:\"592d363f33ae3460df70aa58180898f1\";s:12:\"smw_fpt_text\";s:32:\"d17f10b8853c26c9dbb0e519dcec0e35\";}'),(54,102,'Foaf:name','','','foaf:name','a:6:{s:15:\"smw_di_wikipage\";s:32:\"ee946de4502e39c1f9990966cb6419a3\";s:12:\"smw_fpt_type\";s:32:\"6232f25c15d4db4d6d6c4e4e9241f548\";s:12:\"smw_fpt_inst\";s:32:\"9cc4831a7b589a83889b0f81cad8c953\";s:12:\"smw_fpt_impo\";s:32:\"7902a6a4014904e75c39c686f6211068\";s:14:\"smw_fpt_dtitle\";s:32:\"71cf176e751b694db70aacbbc6aaced1\";s:12:\"smw_fpt_mdat\";s:32:\"854dd234d7826541567e23946911010f\";}'),(55,102,'Foaf:name','','_MLb34778903f2ea2b7ff9e66509498d80c','Foaf:name#A name for some thing or agent.;en','a:2:{s:13:\"smw_fpt_lcode\";s:32:\"2ccaf772a914d21b9428ad3d5732d278\";s:12:\"smw_fpt_text\";s:32:\"25b47662a4950ee0bbf50be435ec5718\";}'),(56,102,'Foaf:homepage','','','foaf:homepage','a:6:{s:15:\"smw_di_wikipage\";s:32:\"19cd97ad829ff92862ff80bcda5feece\";s:12:\"smw_fpt_type\";s:32:\"6bdaa2cf92232777675bf42163b305f8\";s:12:\"smw_fpt_inst\";s:32:\"92e67053f92d5906f4ce1626d76f9941\";s:12:\"smw_fpt_impo\";s:32:\"90164659f5d87d4840f7daa65bca8b19\";s:14:\"smw_fpt_dtitle\";s:32:\"8d511e8cf1fdc4edcb8098f43d72f498\";s:12:\"smw_fpt_mdat\";s:32:\"44dbf1b9312c779df5c802b2a8ddb7c5\";}'),(57,102,'Foaf:homepage','','_ML67cc4c9bb5a2db39eb8b56a98bef5c3c','Foaf:homepage#URL of the homepage of something, which is a general web resource.;en','a:2:{s:13:\"smw_fpt_lcode\";s:32:\"657402a9f2e82cab32a7458c57e77b45\";s:12:\"smw_fpt_text\";s:32:\"7c49e8048db615295f07d91bcb51e97b\";}'),(58,102,'Owl:differentFrom','','','owl:differentFrom','a:6:{s:15:\"smw_di_wikipage\";s:32:\"4a319bea4f8ec1b6da3326a8b0d17cc0\";s:12:\"smw_fpt_type\";s:32:\"cccd7181f0888d227048f163c47aea4f\";s:12:\"smw_fpt_inst\";s:32:\"84c69189d92e0b8e6bf48696e2a6cf63\";s:12:\"smw_fpt_impo\";s:32:\"6429f607a8b05dd499f10218e6cb6543\";s:14:\"smw_fpt_dtitle\";s:32:\"3d9636b63ffc95494b3c1519b9f86c86\";s:12:\"smw_fpt_mdat\";s:32:\"b20ba07cefcc84d06831ee40e648d5fd\";}'),(59,102,'Owl:differentFrom','','_MLfd7bd12e79f4fda5e1abf9d5e6b28dcf','Owl:differentFrom#The property that determines that two given individuals are different.;en','a:2:{s:13:\"smw_fpt_lcode\";s:32:\"727514599106390c228b3f2e6ace0228\";s:12:\"smw_fpt_text\";s:32:\"b80445a0c630fcbe9fe72dca30003a28\";}');
/*!40000 ALTER TABLE `smw_object_ids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_prop_stats`
--

DROP TABLE IF EXISTS `smw_prop_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_prop_stats` (
  `p_id` int(8) unsigned DEFAULT NULL,
  `usage_count` int(8) unsigned DEFAULT NULL,
  UNIQUE KEY `p_id` (`p_id`),
  KEY `usage_count` (`usage_count`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_prop_stats`
--

LOCK TABLES `smw_prop_stats` WRITE;
/*!40000 ALTER TABLE `smw_prop_stats` DISABLE KEYS */;
INSERT INTO `smw_prop_stats` VALUES (1,4),(2,0),(4,4),(7,0),(8,4),(9,0),(10,4),(11,0),(12,0),(13,0),(14,0),(15,0),(16,4),(17,0),(18,0),(19,0),(22,0),(28,0),(29,4),(30,0),(31,0),(32,0),(33,0),(34,0),(35,0),(36,0),(37,0),(38,0),(39,0),(40,4),(41,4),(51,0),(53,0),(54,0),(55,0),(56,0),(57,0),(58,0),(59,0);
/*!40000 ALTER TABLE `smw_prop_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smw_query_links`
--

DROP TABLE IF EXISTS `smw_query_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smw_query_links` (
  `s_id` int(8) unsigned NOT NULL,
  `o_id` int(8) unsigned NOT NULL,
  KEY `s_id` (`s_id`),
  KEY `o_id` (`o_id`),
  KEY `s_id_2` (`s_id`,`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smw_query_links`
--

LOCK TABLES `smw_query_links` WRITE;
/*!40000 ALTER TABLE `smw_query_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `smw_query_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag_summary`
--

DROP TABLE IF EXISTS `tag_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_summary` (
  `ts_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ts_rc_id` int(11) DEFAULT NULL,
  `ts_log_id` int(10) unsigned DEFAULT NULL,
  `ts_rev_id` int(10) unsigned DEFAULT NULL,
  `ts_tags` blob NOT NULL,
  PRIMARY KEY (`ts_id`),
  UNIQUE KEY `tag_summary_rc_id` (`ts_rc_id`),
  UNIQUE KEY `tag_summary_log_id` (`ts_log_id`),
  UNIQUE KEY `tag_summary_rev_id` (`ts_rev_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag_summary`
--

LOCK TABLES `tag_summary` WRITE;
/*!40000 ALTER TABLE `tag_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `tag_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templatelinks`
--

DROP TABLE IF EXISTS `templatelinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `templatelinks` (
  `tl_from` int(10) unsigned NOT NULL DEFAULT '0',
  `tl_from_namespace` int(11) NOT NULL DEFAULT '0',
  `tl_namespace` int(11) NOT NULL DEFAULT '0',
  `tl_title` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`tl_from`,`tl_namespace`,`tl_title`),
  KEY `tl_namespace` (`tl_namespace`,`tl_title`,`tl_from`),
  KEY `tl_backlinks_namespace` (`tl_from_namespace`,`tl_namespace`,`tl_title`,`tl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templatelinks`
--

LOCK TABLES `templatelinks` WRITE;
/*!40000 ALTER TABLE `templatelinks` DISABLE KEYS */;
/*!40000 ALTER TABLE `templatelinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `text`
--

DROP TABLE IF EXISTS `text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `text` (
  `old_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `old_text` mediumblob NOT NULL,
  `old_flags` tinyblob NOT NULL,
  PRIMARY KEY (`old_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=binary MAX_ROWS=10000000 AVG_ROW_LENGTH=10240;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `text`
--

LOCK TABLES `text` WRITE;
/*!40000 ALTER TABLE `text` DISABLE KEYS */;
INSERT INTO `text` VALUES (1,'<strong>MediaWiki has been installed.</strong>\n\nConsult the [https://www.mediawiki.org/wiki/Special:MyLanguage/Help:Contents User\'s Guide] for information on using the wiki software.\n\n== Getting started ==\n* [https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:Configuration_settings Configuration settings list]\n* [https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:FAQ MediaWiki FAQ]\n* [https://lists.wikimedia.org/mailman/listinfo/mediawiki-announce MediaWiki release mailing list]\n* [https://www.mediawiki.org/wiki/Special:MyLanguage/Localisation#Translation_resources Localise MediaWiki for your language]\n* [https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:Combating_spam Learn how to combat spam on your wiki]','utf-8'),(2,'http://www.w3.org/2004/02/skos/core#|[http://www.w3.org/TR/skos-reference/skos.rdf Simple Knowledge Organization System (SKOS)]\n altLabel|Type:Monolingual text\n broader|Type:Annotation URI\n broaderTransitive|Type:Annotation URI\n broadMatch|Type:Annotation URI\n changeNote|Type:Text\n closeMatch|Type:Annotation URI\n Collection|Class\n Concept|Class\n ConceptScheme|Class\n definition|Type:Text\n editorialNote|Type:Text\n exactMatch|Type:Annotation URI\n example|Type:Text\n hasTopConcept|Type:Page\n hiddenLabel|Type:String\n historyNote|Type:Text\n inScheme|Type:Page\n mappingRelation|Type:Page\n member|Type:Page\n memberList|Type:Page\n narrower|Type:Annotation URI\n narrowerTransitive|Type:Annotation URI\n narrowMatch|Type:Annotation URI\n notation|Type:Text\n note|Type:Text\n OrderedCollection|Class\n prefLabel|Type:String\n related|Type:Annotation URI\n relatedMatch|Type:Annotation URI\n scopeNote|Type:Text\n semanticRelation|Type:Page\n topConceptOf|Type:Page\n\n[[Category:Imported vocabulary]]','utf-8'),(3,'http://xmlns.com/foaf/0.1/|[http://www.foaf-project.org/ Friend Of A Friend]\n name|Type:Text\n homepage|Type:URL\n mbox|Type:Email\n mbox_sha1sum|Type:Text\n depiction|Type:URL\n phone|Type:Text\n Person|Category\n Organization|Category\n knows|Type:Page\n member|Type:Page\n\n[[Category:Imported vocabulary]]','utf-8'),(4,'http://www.w3.org/2002/07/owl#|[http://www.w3.org/2002/07/owl Web Ontology Language (OWL)]\n AllDifferent|Category\n allValuesFrom|Type:Page\n AnnotationProperty|Category\n backwardCompatibleWith|Type:Page\n cardinality|Type:Number\n Class|Category\n comment|Type:Page\n complementOf|Type:Page\n DataRange|Category\n DatatypeProperty|Category\n DeprecatedClass|Category\n DeprecatedProperty|Category\n differentFrom|Type:Page\n disjointWith|Type:Page\n distinctMembers|Type:Page\n equivalentClass|Type:Page\n equivalentProperty|Type:Page\n FunctionalProperty|Category\n hasValue|Type:Page\n imports|Type:Page\n incompatibleWith|Type:Page\n intersectionOf|Type:Page\n InverseFunctionalProperty|Category\n inverseOf|Type:Page\n isDefinedBy|Type:Page\n label|Type:Page\n maxCardinality|Type:Number\n minCardinality|Type:Number\n Nothing|Category\n ObjectProperty|Category\n oneOf|Type:Page\n onProperty|Type:Page\n Ontology|Category\n OntologyProperty|Category\n owl|Type:Page\n priorVersion|Type:Page\n Restriction|Category\n sameAs|Type:Page\n seeAlso|Type:Page\n someValuesFrom|Type:Page\n SymmetricProperty|Category\n Thing|Category\n TransitiveProperty|Category\n unionOf|Type:Page\n versionInfo|Type:Page\n\n[[Category:Imported vocabulary]]','utf-8'),(5,'* [[Imported from::foaf:knows]] \n* [[Has property description::A person known by this person (indicating some level of reciprocated interaction between the parties).@en]] \n\n[[Category:Imported vocabulary]] {{DISPLAYTITLE:foaf:knows}}','utf-8'),(6,'* [[Imported from::foaf:name]] \n* [[Has property description::A name for some thing or agent.@en]] \n\n[[Category:Imported vocabulary]]{{DISPLAYTITLE:foaf:name}}','utf-8'),(7,'* [[Imported from::foaf:homepage]] \n* [[Has property description::URL of the homepage of something, which is a general web resource.@en]] \n\n[[Category:Imported vocabulary]] {{DISPLAYTITLE:foaf:homepage}}','utf-8'),(8,'* [[Imported from::owl:differentFrom]] \n* [[Has property description::The property that determines that two given individuals are different.@en]] \n\n[[Category:Imported vocabulary]] {{DISPLAYTITLE:owl:differentFrom}}','utf-8'),(9,'@[[Käyttäjä:{{{1|Example}}}|{{{2|{{{1|Example}}}}}}]]','utf-8'),(10,'This post by {{{author}}} was moved on {{{date}}}. You can find it at [[{{{title}}}]].','utf-8'),(11,'Previous page history was archived for backup purposes at <span class=\'flow-link-to-archive\'>[[{{{archive}}}]]</span> on {{#time: Y-m-d|{{{date}}}}}.','utf-8'),(12,'This page is an archived LiquidThreads page. <strong>Do not edit the contents of this page</strong>. Please direct any additional comments to the [[{{{from}}}|current talk page]].','utf-8'),(13,'This revision was imported from LiquidThreads with a suppressed user. It has been reassigned to the current user.','utf-8'),(14,'<em>This post was posted by [[User:{{{authorUser}}}|{{{authorUser}}}]], but signed as [[User:{{{signatureUser}}}|{{{signatureUser}}}]].</em>','utf-8'),(15,'Previous discussion was archived at <span class=\'flow-link-to-archive\'>[[{{{archive}}}]]</span> on {{#time: Y-m-d|{{{date}}}}}.','utf-8'),(16,'Tämä sivu on arkisto. <strong>Älä muokkaa tätä sivua</strong>. Kaikki uudet kommentit aiheesta kuuluvat [[{{{from|{{TALKSPACE}}:{{BASEPAGENAME}}}}}|nykyiselle keskustelusivulle]].','utf-8');
/*!40000 ALTER TABLE `text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transcache`
--

DROP TABLE IF EXISTS `transcache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transcache` (
  `tc_url` varbinary(255) NOT NULL,
  `tc_contents` blob,
  `tc_time` binary(14) DEFAULT NULL,
  PRIMARY KEY (`tc_url`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transcache`
--

LOCK TABLES `transcache` WRITE;
/*!40000 ALTER TABLE `transcache` DISABLE KEYS */;
/*!40000 ALTER TABLE `transcache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `updatelog`
--

DROP TABLE IF EXISTS `updatelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updatelog` (
  `ul_key` varbinary(255) NOT NULL,
  `ul_value` blob,
  PRIMARY KEY (`ul_key`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updatelog`
--

LOCK TABLES `updatelog` WRITE;
/*!40000 ALTER TABLE `updatelog` DISABLE KEYS */;
INSERT INTO `updatelog` VALUES ('AddRFCAndPMIDInterwiki',NULL),('ChangeChangeObjectId.sql',NULL),('DeleteDefaultMessages',NULL),('FixDefaultJsonContentPages',NULL),('FlowBetaFeatureDisable',NULL),('FlowCreateTemplates:26baf169ef42d3bfcec7f3f2d84634c6',NULL),('FlowFixInconsistentBoards:version1',NULL),('FlowFixLinks:v2',NULL),('FlowFixLog:version2',NULL),('FlowPopulateLinksTables',NULL),('FlowPopulateRefId',NULL),('FlowSetUserIp',NULL),('FlowUpdateRecentChanges',NULL),('FlowUpdateRevisionTypeId',NULL),('FlowUpdateUserWiki',NULL),('FlowUpdateWorkflowPageId',NULL),('Wikibase\\RebuildTermsSearchKey',NULL),('Wikibase\\Repo\\Maintenance\\PopulateTermFullEntityId',NULL),('cl_fields_update',NULL),('cleanup empty categories',NULL),('convert transcache field',NULL),('filearchive-fa_major_mime-patch-fa_major_mime-chemical.sql',NULL),('fix protocol-relative URLs in externallinks',NULL),('flow_ext_ref-ref_target-/srv/mediawiki/workdir/extensions/Flow/db_patches/patch-ref_target_not_null.sql',NULL),('flow_revision-rev_change_type-/srv/mediawiki/workdir/extensions/Flow/db_patches/patch-censor_to_suppress.sql',NULL),('flow_revision-rev_change_type-/srv/mediawiki/workdir/extensions/Flow/db_patches/patch-rev_change_type_update.sql',NULL),('flow_revision-rev_user_ip-/srv/mediawiki/workdir/extensions/Flow/db_patches/patch-revision_user_ip.sql',NULL),('flow_workflow-workflow_id-/srv/mediawiki/workdir/extensions/Flow/db_patches/patch-88bit_uuids.sql',NULL),('flow_workflow-workflow_wiki-/srv/mediawiki/workdir/extensions/Flow/db_patches/patch-increase_width_wiki_fields.sql',NULL),('image-img_major_mime-patch-img_major_mime-chemical.sql',NULL),('image-img_media_type-patch-add-3d.sql',NULL),('mime_minor_length',NULL),('oldimage-oi_major_mime-patch-oi_major_mime-chemical.sql',NULL),('populate *_from_namespace',NULL),('populate category',NULL),('populate fa_sha1',NULL),('populate img_sha1',NULL),('populate ip_changes',NULL),('populate log_search',NULL),('populate log_usertext',NULL),('populate rev_len and ar_len',NULL),('populate rev_parent_id',NULL),('populate rev_sha1',NULL),('recentchanges-rc_ip-patch-rc_ip_modify.sql',NULL),('recentchanges-rc_source-/srv/mediawiki/workdir/extensions/Flow/db_patches/patch-rc_source.sql',NULL),('user_former_groups-ufg_group-patch-ufg_group-length-increase-255.sql',NULL),('user_groups-ug_group-patch-ug_group-length-increase-255.sql',NULL),('user_properties-up_property-patch-up_property.sql',NULL),('wb_changes-change_info-/srv/mediawiki/workdir/extensions/Wikibase/repo/includes/Store/Sql/../../../sql/MakeChangeInfoLarger.sql',NULL),('wb_items_per_site-ips_site_page-/srv/mediawiki/workdir/extensions/Wikibase/repo/includes/Store/Sql/../../../sql/MakeIpsSitePageLarger.sql',NULL),('wb_terms-term_row_id-/srv/mediawiki/workdir/extensions/Wikibase/repo/includes/Store/Sql/../../../sql/MakeRowIDsBig.sql',NULL);
/*!40000 ALTER TABLE `updatelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uploadstash`
--

DROP TABLE IF EXISTS `uploadstash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uploadstash` (
  `us_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `us_user` int(10) unsigned NOT NULL,
  `us_key` varbinary(255) NOT NULL,
  `us_orig_path` varbinary(255) NOT NULL,
  `us_path` varbinary(255) NOT NULL,
  `us_source_type` varbinary(50) DEFAULT NULL,
  `us_timestamp` varbinary(14) NOT NULL,
  `us_status` varbinary(50) NOT NULL,
  `us_chunk_inx` int(10) unsigned DEFAULT NULL,
  `us_props` blob,
  `us_size` int(10) unsigned NOT NULL,
  `us_sha1` varbinary(31) NOT NULL,
  `us_mime` varbinary(255) DEFAULT NULL,
  `us_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `us_image_width` int(10) unsigned DEFAULT NULL,
  `us_image_height` int(10) unsigned DEFAULT NULL,
  `us_image_bits` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`us_id`),
  UNIQUE KEY `us_key` (`us_key`),
  KEY `us_user` (`us_user`),
  KEY `us_timestamp` (`us_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uploadstash`
--

LOCK TABLES `uploadstash` WRITE;
/*!40000 ALTER TABLE `uploadstash` DISABLE KEYS */;
/*!40000 ALTER TABLE `uploadstash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varbinary(255) NOT NULL DEFAULT '',
  `user_real_name` varbinary(255) NOT NULL DEFAULT '',
  `user_password` tinyblob NOT NULL,
  `user_newpassword` tinyblob NOT NULL,
  `user_newpass_time` binary(14) DEFAULT NULL,
  `user_email` tinyblob NOT NULL,
  `user_touched` binary(14) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `user_token` binary(32) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `user_email_authenticated` binary(14) DEFAULT NULL,
  `user_email_token` binary(32) DEFAULT NULL,
  `user_email_token_expires` binary(14) DEFAULT NULL,
  `user_registration` binary(14) DEFAULT NULL,
  `user_editcount` int(11) DEFAULT NULL,
  `user_password_expires` varbinary(14) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  KEY `user_email_token` (`user_email_token`),
  KEY `user_email` (`user_email`(50))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'WikiSysop','',':pbkdf2:sha512:30000:64:Ub6U3BJDRhd+IzZ9TEFH+w==:TngDMvsY87xrCID2VdTX91bpEtRCSl+uzpfcWgj4w/ZBNt9gXMhL53qWsFp7ZinlPN9qHiV97E2/U/hXj62fGg==','',NULL,'','20171205190159','136d229b8af1ae98970564183eeb0d43',NULL,'\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',NULL,'20171205190152',0,NULL),(2,'Flow talk page manager','','','',NULL,'','20171205190623','*** INVALID ***\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',NULL,NULL,NULL,'20171205190618',8,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_former_groups`
--

DROP TABLE IF EXISTS `user_former_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_former_groups` (
  `ufg_user` int(10) unsigned NOT NULL DEFAULT '0',
  `ufg_group` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ufg_user`,`ufg_group`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_former_groups`
--

LOCK TABLES `user_former_groups` WRITE;
/*!40000 ALTER TABLE `user_former_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_former_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_groups` (
  `ug_user` int(10) unsigned NOT NULL DEFAULT '0',
  `ug_group` varbinary(255) NOT NULL DEFAULT '',
  `ug_expiry` varbinary(14) DEFAULT NULL,
  PRIMARY KEY (`ug_user`,`ug_group`),
  KEY `ug_group` (`ug_group`),
  KEY `ug_expiry` (`ug_expiry`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_groups`
--

LOCK TABLES `user_groups` WRITE;
/*!40000 ALTER TABLE `user_groups` DISABLE KEYS */;
INSERT INTO `user_groups` VALUES (1,'bureaucrat',NULL),(1,'sysop',NULL),(2,'bot',NULL),(2,'flow-bot',NULL);
/*!40000 ALTER TABLE `user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_newtalk`
--

DROP TABLE IF EXISTS `user_newtalk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_newtalk` (
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `user_ip` varbinary(40) NOT NULL DEFAULT '',
  `user_last_timestamp` varbinary(14) DEFAULT NULL,
  KEY `user_id` (`user_id`),
  KEY `user_ip` (`user_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_newtalk`
--

LOCK TABLES `user_newtalk` WRITE;
/*!40000 ALTER TABLE `user_newtalk` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_newtalk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_properties`
--

DROP TABLE IF EXISTS `user_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_properties` (
  `up_user` int(10) unsigned NOT NULL,
  `up_property` varbinary(255) NOT NULL,
  `up_value` blob,
  PRIMARY KEY (`up_user`,`up_property`),
  KEY `user_properties_property` (`up_property`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_properties`
--

LOCK TABLES `user_properties` WRITE;
/*!40000 ALTER TABLE `user_properties` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `valid_tag`
--

DROP TABLE IF EXISTS `valid_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `valid_tag` (
  `vt_tag` varbinary(255) NOT NULL,
  PRIMARY KEY (`vt_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valid_tag`
--

LOCK TABLES `valid_tag` WRITE;
/*!40000 ALTER TABLE `valid_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `valid_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `watchlist`
--

DROP TABLE IF EXISTS `watchlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watchlist` (
  `wl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wl_user` int(10) unsigned NOT NULL,
  `wl_namespace` int(11) NOT NULL DEFAULT '0',
  `wl_title` varbinary(255) NOT NULL DEFAULT '',
  `wl_notificationtimestamp` varbinary(14) DEFAULT NULL,
  PRIMARY KEY (`wl_id`),
  UNIQUE KEY `wl_user` (`wl_user`,`wl_namespace`,`wl_title`),
  KEY `namespace_title` (`wl_namespace`,`wl_title`),
  KEY `wl_user_notificationtimestamp` (`wl_user`,`wl_notificationtimestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `watchlist`
--

LOCK TABLES `watchlist` WRITE;
/*!40000 ALTER TABLE `watchlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `watchlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wb_changes`
--

DROP TABLE IF EXISTS `wb_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wb_changes` (
  `change_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `change_type` varbinary(25) NOT NULL,
  `change_time` varbinary(14) NOT NULL,
  `change_object_id` varbinary(14) NOT NULL,
  `change_revision_id` int(10) unsigned NOT NULL,
  `change_user_id` int(10) unsigned NOT NULL,
  `change_info` mediumblob NOT NULL,
  PRIMARY KEY (`change_id`),
  KEY `wb_changes_change_type` (`change_type`),
  KEY `wb_changes_change_time` (`change_time`),
  KEY `wb_changes_change_object_id` (`change_object_id`),
  KEY `wb_changes_change_user_id` (`change_user_id`),
  KEY `wb_changes_change_revision_id` (`change_revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wb_changes`
--

LOCK TABLES `wb_changes` WRITE;
/*!40000 ALTER TABLE `wb_changes` DISABLE KEYS */;
/*!40000 ALTER TABLE `wb_changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wb_changes_dispatch`
--

DROP TABLE IF EXISTS `wb_changes_dispatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wb_changes_dispatch` (
  `chd_site` varbinary(32) NOT NULL,
  `chd_db` varbinary(32) NOT NULL,
  `chd_seen` int(11) NOT NULL DEFAULT '0',
  `chd_touched` varbinary(14) NOT NULL DEFAULT '00000000000000',
  `chd_lock` varbinary(64) DEFAULT NULL,
  `chd_disabled` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`chd_site`),
  KEY `wb_changes_dispatch_chd_seen` (`chd_seen`),
  KEY `wb_changes_dispatch_chd_touched` (`chd_touched`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wb_changes_dispatch`
--

LOCK TABLES `wb_changes_dispatch` WRITE;
/*!40000 ALTER TABLE `wb_changes_dispatch` DISABLE KEYS */;
/*!40000 ALTER TABLE `wb_changes_dispatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wb_changes_subscription`
--

DROP TABLE IF EXISTS `wb_changes_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wb_changes_subscription` (
  `cs_row_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cs_entity_id` varbinary(255) NOT NULL,
  `cs_subscriber_id` varbinary(255) NOT NULL,
  PRIMARY KEY (`cs_row_id`),
  UNIQUE KEY `cs_entity_id` (`cs_entity_id`,`cs_subscriber_id`),
  KEY `cs_subscriber_id` (`cs_subscriber_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wb_changes_subscription`
--

LOCK TABLES `wb_changes_subscription` WRITE;
/*!40000 ALTER TABLE `wb_changes_subscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `wb_changes_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wb_id_counters`
--

DROP TABLE IF EXISTS `wb_id_counters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wb_id_counters` (
  `id_value` int(10) unsigned NOT NULL,
  `id_type` varbinary(32) NOT NULL,
  UNIQUE KEY `wb_id_counters_type` (`id_type`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wb_id_counters`
--

LOCK TABLES `wb_id_counters` WRITE;
/*!40000 ALTER TABLE `wb_id_counters` DISABLE KEYS */;
/*!40000 ALTER TABLE `wb_id_counters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wb_items_per_site`
--

DROP TABLE IF EXISTS `wb_items_per_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wb_items_per_site` (
  `ips_row_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ips_item_id` int(10) unsigned NOT NULL,
  `ips_site_id` varbinary(32) NOT NULL,
  `ips_site_page` varbinary(310) NOT NULL,
  PRIMARY KEY (`ips_row_id`),
  UNIQUE KEY `wb_ips_item_site_page` (`ips_site_id`,`ips_site_page`),
  KEY `wb_ips_site_page` (`ips_site_page`),
  KEY `wb_ips_item_id` (`ips_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wb_items_per_site`
--

LOCK TABLES `wb_items_per_site` WRITE;
/*!40000 ALTER TABLE `wb_items_per_site` DISABLE KEYS */;
/*!40000 ALTER TABLE `wb_items_per_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wb_property_info`
--

DROP TABLE IF EXISTS `wb_property_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wb_property_info` (
  `pi_property_id` int(10) unsigned NOT NULL,
  `pi_type` varbinary(32) NOT NULL,
  `pi_info` blob NOT NULL,
  PRIMARY KEY (`pi_property_id`),
  KEY `pi_type` (`pi_type`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wb_property_info`
--

LOCK TABLES `wb_property_info` WRITE;
/*!40000 ALTER TABLE `wb_property_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `wb_property_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wb_terms`
--

DROP TABLE IF EXISTS `wb_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wb_terms` (
  `term_row_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_entity_id` int(10) unsigned NOT NULL,
  `term_full_entity_id` varbinary(32) DEFAULT NULL,
  `term_entity_type` varbinary(32) NOT NULL,
  `term_language` varbinary(32) NOT NULL,
  `term_type` varbinary(32) NOT NULL,
  `term_text` varbinary(255) NOT NULL,
  `term_search_key` varbinary(255) NOT NULL,
  `term_weight` float unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`term_row_id`),
  KEY `term_entity` (`term_entity_id`),
  KEY `term_full_entity` (`term_full_entity_id`),
  KEY `term_text` (`term_text`,`term_language`),
  KEY `term_search_key` (`term_search_key`,`term_language`),
  KEY `term_search` (`term_language`,`term_entity_id`,`term_type`,`term_search_key`(16)),
  KEY `term_search_full` (`term_language`,`term_full_entity_id`,`term_type`,`term_search_key`(16))
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wb_terms`
--

LOCK TABLES `wb_terms` WRITE;
/*!40000 ALTER TABLE `wb_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `wb_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wbc_entity_usage`
--

DROP TABLE IF EXISTS `wbc_entity_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wbc_entity_usage` (
  `eu_row_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `eu_entity_id` varbinary(255) NOT NULL,
  `eu_aspect` varbinary(37) NOT NULL,
  `eu_page_id` int(11) NOT NULL,
  PRIMARY KEY (`eu_row_id`),
  UNIQUE KEY `eu_entity_id` (`eu_entity_id`,`eu_aspect`,`eu_page_id`),
  KEY `eu_page_id` (`eu_page_id`,`eu_entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wbc_entity_usage`
--

LOCK TABLES `wbc_entity_usage` WRITE;
/*!40000 ALTER TABLE `wbc_entity_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `wbc_entity_usage` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-12-05 20:36:57
