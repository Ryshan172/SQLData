USE [master]
GO
/****** Object:  Database [MovieDB]    Script Date: 2024/02/07 15:46:34 ******/
CREATE DATABASE [MovieDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MovieDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\MovieDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MovieDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\MovieDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MovieDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MovieDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MovieDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MovieDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MovieDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MovieDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MovieDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MovieDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [MovieDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MovieDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MovieDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MovieDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MovieDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MovieDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MovieDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MovieDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MovieDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MovieDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MovieDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MovieDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MovieDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MovieDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MovieDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MovieDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MovieDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MovieDB] SET  MULTI_USER 
GO
ALTER DATABASE [MovieDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MovieDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MovieDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MovieDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MovieDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MovieDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MovieDB] SET QUERY_STORE = OFF
GO
USE [MovieDB]
GO
/****** Object:  UserDefinedFunction [dbo].[udfAverageActorAge]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udfAverageActorAge]
(
@MovieID int
)
RETURNS int
AS
BEGIN
	DECLARE @AvgAge int 

	SELECT @AvgAge = AVG(Age) FROM Actors
	WHERE MovieID = @MovieID
	RETURN @AvgAge
END

GO
/****** Object:  Table [dbo].[Movies]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movies](
	[MovieID] [int] IDENTITY(1,1) NOT NULL,
	[MovieName] [varchar](120) NULL,
	[ReleaseDate] [date] NULL,
	[RunningTime] [int] NULL,
	[MovieDescription] [varchar](8000) NULL,
	[Genre] [varchar](1000) NULL,
	[MoviePoster] [varbinary](max) NULL,
 CONSTRAINT [PK_Movies] PRIMARY KEY CLUSTERED 
(
	[MovieID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vMovies]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vMovies]
AS
SELECT [MovieName],
[ReleaseDate],
[RunningTime],
[MovieDescription],
[Genre]
FROM Movies
GO
/****** Object:  Table [dbo].[Directors]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Directors](
	[DirectorID] [int] IDENTITY(1,1) NOT NULL,
	[MovieID] [int] NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](120) NULL,
	[BirthDate] [date] NULL,
	[DirectorImage] [varbinary](max) NULL,
	[BirthPlace] [varchar](80) NULL,
	[CountryOfBirth] [varchar](100) NULL,
 CONSTRAINT [PK_Directors] PRIMARY KEY CLUSTERED 
(
	[DirectorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vDirectors]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vDirectors]
AS
SELECT MovieID,
		FirstName,
		LastName,
		BirthDate,
		BirthPlace,
		CountryOfBirth,
		DATEDIFF(YEAR, BirthDate, GETDATE()) AS 'Age'
FROM Directors
GO
/****** Object:  Table [dbo].[Producers]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producers](
	[ProducerID] [int] IDENTITY(1,1) NOT NULL,
	[MovieID] [int] NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](120) NULL,
	[BirthDate] [date] NULL,
	[ProducerImage] [varbinary](max) NULL,
	[BirthPlace] [varchar](80) NULL,
	[CountryOfBirth] [varchar](100) NULL,
 CONSTRAINT [PK_Producers] PRIMARY KEY CLUSTERED 
(
	[ProducerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vProducers]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vProducers]
AS
SELECT MovieID,
		FirstName,
		LastName,
		BirthDate,
		BirthPlace,
		CountryOfBirth,
		DATEDIFF(YEAR, BirthDate, GETDATE()) AS 'Age'
FROM Producers

GO
/****** Object:  Table [dbo].[Writers]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Writers](
	[WriterID] [int] IDENTITY(1,1) NOT NULL,
	[MovieID] [int] NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](120) NULL,
	[BirthDate] [date] NULL,
	[WriterImage] [varbinary](max) NULL,
	[BirthPlace] [varchar](80) NULL,
	[CountryOfBirth] [varchar](100) NULL,
 CONSTRAINT [PK_Writers] PRIMARY KEY CLUSTERED 
(
	[WriterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vWriters]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vWriters]
AS
SELECT MovieID,
		FirstName,
		LastName,
		BirthDate,
		BirthPlace,
		CountryOfBirth,
		DATEDIFF(YEAR, BirthDate, GETDATE()) AS 'Age'
FROM Writers

GO
/****** Object:  Table [dbo].[Actors]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Actors](
	[ActorID] [int] IDENTITY(1,1) NOT NULL,
	[MovieID] [int] NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](120) NULL,
	[BirthDate] [date] NULL,
	[ActorImage] [varbinary](max) NULL,
	[BirthPlace] [varchar](80) NOT NULL,
	[CountryOfBirth] [varchar](100) NOT NULL,
	[Age]  AS (datediff(year,[BirthDate],getdate())),
 CONSTRAINT [PK_Actors] PRIMARY KEY CLUSTERED 
(
	[ActorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vActors]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vActors]
AS
SELECT MovieID,
		FirstName,
		LastName,
		BirthDate,
		BirthPlace,
		CountryOfBirth,
		DATEDIFF(YEAR, BirthDate, GETDATE()) AS 'Age'
FROM Actors

GO
/****** Object:  Table [dbo].[ActorUpdates]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActorUpdates](
	[MovieID] [int] NULL,
	[FirstName] [varchar](80) NULL,
	[LastName] [varchar](120) NULL,
	[BirthDate] [date] NULL,
	[BirthPlace] [varchar](80) NULL,
	[CountryOfBirth] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genres]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genres](
	[GenreID] [int] IDENTITY(1,1) NOT NULL,
	[GenreName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Genres] PRIMARY KEY CLUSTERED 
(
	[GenreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[uspChangeActors]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspChangeActors]
	@FirstName char 
AS
	SELECT FirstName FROM Actors WHERE ActorID=1
	BEGIN TRANSACTION 
	UPDATE Actors set FirstName = FirstName WHERE ActorID=1;
	SELECT FirstName FROM Actors WHERE ActorID=1;
	ROLLBACK 
	SELECT FirstName FROM Actors WHERE ActorID=1;




GO
/****** Object:  StoredProcedure [dbo].[uspGetActorInfo]    Script Date: 2024/02/07 15:46:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspGetActorInfo]
		@MovieID int ,
		@WriterID int = NULL
AS
SELECT m.MovieName,
		m.ReleaseDate,
		CAST(m.RunningTime / 60 AS varchar(5)) + 'H ' + 
		CAST(m.RunningTime % 60 AS varchar(5)) + 'M' AS MovieLength,
		m.Genre,
		a.FirstName + ' ' + a.LastName AS ActorName,
		DATEDIFF(YEAR, a.BirthDate,GETDATE()) AS ActorAge,
		a.BirthPlace + ', ' + a.CountryOfBirth
FROM Movies m
INNER JOIN Actors a
	ON m.MovieID = a.MovieID
WHERE m.MovieID = @MovieID

IF NOT @WriterID IS NULL
SELECT MovieID,
		FirstName,
		LastName,
		BirthDate,
		BirthPlace,
		CountryOfBirth,
		DATEDIFF(YEAR, BirthDate, GETDATE()) AS 'Age'
FROM Writers
WHERE MovieID = @MovieID
AND WriterID = @WriterID


GO
USE [master]
GO
ALTER DATABASE [MovieDB] SET  READ_WRITE 
GO
