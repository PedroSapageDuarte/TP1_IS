USE [Producao]
GO

/****** Object:  Table [dbo].[Produto]    Script Date: 25/03/2025 14:39:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Produto](
	[ID_Produto] [int] IDENTITY(1,1) NOT NULL,
	[Codigo_Peca] [char](8) NOT NULL,
	[Data_Producao] [date] NOT NULL,
	[Hora_Producao] [time](7) NOT NULL,
	[Tempo_Producao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Produto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Codigo_Peca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


