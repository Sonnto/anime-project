-- CREATE ANIME TABLE --
CREATE TABLE IF NOT EXISTS anime (
anime_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
anime_title VARCHAR(255),
type_id INT REFERENCES anime_types(type_id),
opening_song INT REFERENCES opening_songs(song_id),
ending_song INT REFERENCES ending_songs(song_id),
rating INT,
episodes INT,
status VARCHAR(255),
air_date DATE,
end_date DATE,
favourite BOOLEAN)

-- CREATE CHARACTER TABLE --
CREATE TABLE IF NOT EXISTS characters (
character_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
f_name VARCHAR(255),
l_name VARCHAR(255),
gender VARCHAR(1),
anime_title INT REFERENCES anime(anime_id))

-- CREATE SONGS TABLE --
CREATE TABLE IF NOT EXISTS songs (
song_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
song_title VARCHAR(255),
artist_id INT REFERENCES artists(artist_id)
song_type VARCHAR(255),
anime_title INT REFERENCES anime(anime_id))

-- CREATE ARTISTS TABLE --
CREATE TABLE IF NOT EXISTS artists (
artist_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
f_name VARCHAR(255),
l_name VARCHAR(255))

-- CREATE ANIME TYPES TABLE --
CREATE TABLE IF NOT EXISTS anime_types (
anime_type_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
anime_types VARCHAR(255))