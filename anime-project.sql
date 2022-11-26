-- CREATE ANIME TABLE --
CREATE TABLE IF NOT EXISTS anime (
anime_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
anime_title VARCHAR(255),
type_id INT REFERENCES anime_types(anime_type_id),
opening_song INT REFERENCES songs(song_id),
ending_song INT REFERENCES songs(song_id),
rating INT,
episodes INT,
status VARCHAR(255),
air_date DATE,
end_date DATE,
favourite VARCHAR(1),
CONSTRAINT check_rating CHECK (rating <= 10),
CONSTRAINT check_status CHECK ((status = 'UPCOMING')
	OR (status = 'AIRING')
	OR (status = 'COMPLETED')))


-- CREATE CHARACTERS TABLE --
CREATE TABLE IF NOT EXISTS `characters` (
character_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
f_name VARCHAR(255),
l_name VARCHAR(255),
gender VARCHAR(1),
anime_title INT REFERENCES anime(anime_id),
CONSTRAINT check_gender CHECK ((gender = 'M')
	OR (gender = 'F')
	OR (gender = 'X')))

-- CREATE SONGS TABLE --
CREATE TABLE IF NOT EXISTS songs (
song_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
song_title VARCHAR(255),
artist_id INT REFERENCES artists(artist_id),
song_type VARCHAR(2),
anime_title INT REFERENCES anime(anime_id),
CONSTRAINT check_song_type CHECK ((song_type = 'OP')
	OR (song_type = 'ED')))

-- CREATE ARTISTS TABLE --
CREATE TABLE IF NOT EXISTS artists (
artist_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
f_name VARCHAR(255),
l_name VARCHAR(255))

-- CREATE ANIME TYPES TABLE --
CREATE TABLE IF NOT EXISTS anime_types (
anime_type_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
anime_types VARCHAR(255),
CONSTRAINT check_anime_types CHECK ((anime_types = 'TV SERIES')
	OR (anime_types = 'MOVIE')
	OR (anime_types = 'OVA')))

-- INSERT ANIME TYPES DATA --
INSERT INTO anime_types VALUES (NULL, 'TV SERIES'),
(NULL, 'MOVIE'),
(NULL, 'OVA')

-- INSERT ARTISTS DATA --
INSERT INTO artists VALUES

-- INSERT SONGS DATA --
INSERT INTO songs VALUES

-- INSERT CHARACTERS DATA --
INSERT INTO `characters` VALUES

-- INSERT ANIME TYPES DATA --
INSERT INTO anime VALUES