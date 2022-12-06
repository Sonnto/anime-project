-- ==================== TABLE CREATION ==================== --
-- =============== ANIME TABLE =============== --

	DROP TABLE IF EXISTS anime
	
CREATE TABLE IF NOT EXISTS anime (
anime_id INT PRIMARY KEY AUTO_INCREMENT,
anime_title VARCHAR(255) NOT NULL,
anime_type_id INT NOT NULL,
opening_song INT,
ending_song INT,
rating INT,
episodes INT NOT NULL DEFAULT 1,
status VARCHAR(255) NOT NULL,
air_date DATE,
end_date DATE,
favourite BOOLEAN NOT NULL DEFAULT 0,
CONSTRAINT check_episodes CHECK (episodes > 0),
CONSTRAINT check_rating CHECK (rating <= 10),
CONSTRAINT check_status CHECK ((status = 'UPCOMING')
	OR (status = 'AIRING')
	OR (status = 'COMPLETED'))
);

-- ADD FOREIGN KEYS TO ANIME TABLE --

ALTER TABLE anime ADD FOREIGN KEY (anime_type_id)
	REFERENCES anime_types(anime_type_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD FOREIGN KEY (opening_song)
	REFERENCES songs(song_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD FOREIGN KEY (ending_song)
	REFERENCES songs(song_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
	
-- =============== CHARACTERS TABLE =============== --
	
	DROP TABLE IF EXISTS `characters`
	
CREATE TABLE IF NOT EXISTS `characters` (
character_id INT PRIMARY KEY AUTO_INCREMENT,
f_name VARCHAR(255) NOT NULL,
l_name VARCHAR(255) NOT NULL,
gender VARCHAR(1),
anime_title_id INT NOT NULL,
CONSTRAINT check_gender CHECK ((gender = 'M')
	OR (gender = 'F')
	OR (gender = 'X'))
);

-- ADD FOREIGN KEYS TO CHARACTERS TABLE --
	
ALTER TABLE `characters` ADD FOREIGN KEY (anime_title_id)
	REFERENCES anime(anime_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
	
-- =============== SONGS TABLE =============== --
	
	DROP TABLE IF EXISTS songs
	
CREATE TABLE IF NOT EXISTS songs (
song_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
song_title VARCHAR(255) NOT NULL,
artist_id INT NOT NULL,
song_type VARCHAR(255) NOT NULL,
anime_title_id INT NOT NULL,
CONSTRAINT check_song_type CHECK ((song_type = 'OP')
	OR (song_type = 'ED')
	OR (song_type = 'INSERT'))
);

-- ADD FOREIGN KEYS TO SONGS TABLE --

ALTER TABLE songs ADD FOREIGN KEY (artist_id)
	REFERENCES artists(artist_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD FOREIGN KEY (anime_title_id)
	REFERENCES anime(anime_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

-- =============== ARTISTS TABLE =============== --
	
	DROP TABLE IF EXISTS artists
	
CREATE TABLE IF NOT EXISTS artists (
artist_id INT PRIMARY KEY AUTO_INCREMENT,
f_name VARCHAR(255),
l_name VARCHAR(255)
);

-- =============== ANIME TYPES TABLE =============== --

	DROP TABLE IF EXISTS anime_types
	
CREATE TABLE IF NOT EXISTS anime_types (
anime_type_id INT PRIMARY KEY AUTO_INCREMENT,
anime_types VARCHAR(255) NOT NULL,
CONSTRAINT check_anime_types CHECK ((anime_types = 'TV SERIES')
	OR (anime_types = 'MOVIE')
	OR (anime_types = 'OVA'))
);

-- =============== RECENTLY DELETED TABLE =============== --

CREATE TABLE deleted_log (
log_id INT PRIMARY KEY AUTO_INCREMENT,
anime_id INT,
anime_title VARCHAR(255),
anime_type_id INT,
opening_song INT,
ending_song INT,
rating INT,
episodes INT,
status VARCHAR(255),
air_date DATE,
end_date DATE,
favourite BOOLEAN,
timestamp TIMESTAMP
);

-- ==================== DATA INSERTION ==================== --

-- =============== ANIME TYPES TABLE =============== --
-- >> anime_type_id, anime_types;

INSERT INTO anime_types VALUES (NULL, 'TV SERIES'),
(NULL, 'MOVIE'),
(NULL, 'OVA');

-- =============== ARTISTS TABLE =============== --
-- >> artist_id, f_name, l_name;

INSERT INTO artists VALUES (NULL, 'ClariS', NULL),
(NULL, 'Sayuri', NULL),
(NULL, 'RADWIMPS', NULL),
;

-- =============== SONGS TABLE =============== --
-- >> song_id, song_title, artist_id, song_type, anime_title_id;

INSERT INTO songs VALUES (NULL, 'ALIVE', 1, 'OP', 2),
(NULL, 'Hana no Tou', 2, 'ED', 2),
(NULL, 'Sparkle', 3, 'INSERT', 1),

;

-- =============== CHARACTERS TABLE =============== --
-- >> character_id, f_name, l_name, gender, anime_title_id

INSERT INTO `characters` VALUES (NULL, 'Mitsuha', 'Miyamizu', 'F', 1),
(NULL, 'Taki', 'Tachibana', 'M', 1),
(NULL, 'Chisato', 'Nishikigi', 'F', 2),
(NULL, 'Takina', 'Inoue', 'F', 2)
(NULL);

-- =============== ANIME TABLE =============== --
-- >> anime_id, anime_title_id, anime_type_id, opening_song, ending_song, rating, episodes, status, air_date, end_date, favourite

INSERT INTO anime VALUES (NULL,'Kimi No Nawa', 2, NULL, NULL, 10, 24, 'COMPLETED', '2021-11-09', '2022-11-23', 0),
(NULL, 'Lycoris Recoil', 1, 1, 2, 'COMPLETED', '2022-07-02', '2022-09-24', 1),

;

-- ==================== VIEWS ==================== --

-- FAVOURITE VIEW --

	DROP VIEW IF EXISTS myFavouriteAnime
	
CREATE VIEW myFavouriteAnime AS
SELECT anime_title AS 'Title of Anime',
rating AS 'Rating',
air_date AS 'Air Date',
end_date AS 'End Date' FROM anime 
WHERE favourite IS TRUE;

-- ==================== FUNCTIONS ==================== --

DELIMITER //
-- MAIN FUNCTION TO CAPITALIZE NOUNS, PRONOUNS, ETC IN TITLES/NAMES/ETC --

	DROP FUNCTION IF EXISTS properCapitalize
	
CREATE FUNCTION properCapitalize(inputString VARCHAR(255)) -- takes inputted string and outputs a title-caps string
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN 
	DECLARE `char` CHAR(1); -- variable for the single character the function is iterating through
	DECLARE outputString VARCHAR(255); -- variable for the string to be outputted
	DECLARE i INT DEFAULT 1; -- start at 1 not 0 because not actual index
	DECLARE `match` BOOLEAN DEFAULT 1; -- boolean to flag if the character matches any characters, 1-TRUE 0-FALSE
	DECLARE `ignore` CHAR(17) DEFAULT ' .,/?!@-_;:()[]{}'; -- characters to ignore when iterating
	
	SET outputString = inputString;
	
	WHILE i <= LENGTH(inputString) DO -- while i is less than inputString's length, continue to loop
		BEGIN
			SET `char` = SUBSTRING(outputString, i, 1); -- stores single character at the iteration index to variable
			IF LOCATE(`char`, `ignore`) > 0 THEN -- if character matches any characters to be ignored,
				SET `match` = 1; -- set boolean to 1-TRUE to begin the capitalizing effort as it is likely a new word
			ELSEIF `match` = 1 THEN -- else if match = 1-TRUE,
				BEGIN
					IF `char` >= 'a' AND `char` <= 'z' THEN -- check if it is a alphabet/latin character through ascii value 
					BEGIN
						SET outputString = CONCAT(LEFT(outputString, i-1), UPPER(`char`), SUBSTRING(outputString, i+1)); -- caps and rebuilds string: cuts the string and everything to the LEFT of the index, capitalizes the character, and concats the remaining of the string; stored in that variable
						SET `match` = 0; -- reset boolean to 0-FALSE
					END;
					ELSEIF `char` >= '0' AND `char` <= '9' THEN -- check if it is a number; cannot cap numbers, therefore,
					SET `match` = 0; -- set boolean to 0-FALSE
					END IF;
				END;
			END IF;
			SET i = i+1;
		END;
	END WHILE;
 -- uses the other function to assist in replacing the words that should NOT be capitlized in tite casing rules
	SET outputString = dontCapitalize(outputString, 'A');
	SET outputString = dontCapitalize(outputString, 'An');
	SET outputString = dontCapitalize(outputString, 'And');
	SET outputString = dontCapitalize(outputString, 'As');
	SET outputString = dontCapitalize(outputString, 'At');
	SET outputString = dontCapitalize(outputString, 'But');
	SET outputString = dontCapitalize(outputString, 'By');
	SET outputString = dontCapitalize(outputString, 'For');
	SET outputString = dontCapitalize(outputString, 'If');
	SET outputString = dontCapitalize(outputString, 'In');
	SET outputString = dontCapitalize(outputString, 'Of');
	SET outputString = dontCapitalize(outputString, 'On');
	SET outputString = dontCapitalize(outputString, 'Or');
	SET outputString = dontCapitalize(outputString, 'The');
	SET outputString = dontCapitalize(outputString, 'To');
	SET outputString = dontCapitalize(outputString, 'Via');
	RETURN outputString; 
END;
//

-- HELPER FUNCTION TO NOT CAPITALIZE PREPOSITIONS AND ETC IN TITLES/NAMES/ETC --

	DROP FUNCTION IF EXISTS dontCapitalize
	
CREATE FUNCTION dontCapitalize(outputString VARCHAR(255), noCapWord VARCHAR(5)) -- takes outputString that has all words capitalized and lowercases the words that shouldn't be like prepositions, etc.
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE charLocation INT; -- variable holding the location of the character as opposed to its index position and the character itself at said position

	SET charLocation = LOCATE(CONCAT(noCapWord,' '), outputString, 2); -- set variable storing the first appearance of the word we want to lowercase plus a blank space incase the word is a substring of a longer word, i.e. 'for' is within 'forest'; start at the second character to avoid matching potential first words
	IF charLocation > 1 THEN -- if there is a match
		WHILE i <= LENGTH(outputString) AND charLocation <> 0 DO -- while there is characters left to iterate through AND matching word-to-be lowercased is present
			SET outputString = INSERT(outputString, charLocation, LENGTH(noCapWord), LOWER(noCapWord)); -- inserts into the outputString the lowercased version of the word
			SET i = charLocation + LENGTH(noCapWord); -- ensures the interation counter continues after the newly inserted lowercased word
			SET charLocation = LOCATE(CONCAT(noCapWord,' '), outputString, i); -- checks if that word reoccurs again in the outputString
		END WHILE;
	END IF;
	RETURN outputString;
END;
//

DELIMITER ;

-- test --

SELECT properCapitalize('RAMI AND HIS AWESOME BURGERS: THE DELUXE');

-- ==================== TRIGGER ==================== --

DELIMITER //

CREATE TRIGGER recently_deleted
AFTER DELETE ON anime
FOR EACH ROW
BEGIN
	INSERT INTO deleted_log (log_id, anime_id, anime_title, anime_type_id, opening_song, ending_song, rating, episodes, status, air_date, end_date, favourite, timestamp)
    VALUES (NULL, OLD.anime_id, OLD.anime_title, OLD.anime_type_id, OLD.opening_song, OLD.ending_song, OLD.rating, OLD.episodes, OLD.status, OLD.air_date, OLD.end_date, OLD.favourite, NOW());
END;
//

DELIMITER ;