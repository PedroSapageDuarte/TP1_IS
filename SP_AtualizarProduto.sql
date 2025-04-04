USE [Producao]
GO
/****** Object:  StoredProcedure [dbo].[SP_AtualizarProduto]    Script Date: 30/03/2025 11:53:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Declaração da SP
ALTER PROCEDURE [dbo].[SP_AtualizarProduto]
    @id_Produto INT,
    @codigoPeca CHAR(8),
    @dataProducao DATE,
    @horaProducao TIME,
    @tempoProducao INT,
    @codigoResultado CHAR(2),
    @dataTeste DATE            
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verifica se o produto existe
    IF NOT EXISTS (SELECT 1 FROM Produto WHERE ID_Produto = @id_Produto)
    BEGIN
        RAISERROR ('Produto não encontrado.', 16, 1);
        RETURN;
    END
    
    -- Atualiza a tabela Produto
    UPDATE Produto
    SET Codigo_Peca = @codigoPeca,
        Data_Producao = @dataProducao,
        Hora_Producao = @horaProducao,
        Tempo_Producao = @tempoProducao
    WHERE ID_Produto = @id_Produto;

    -- Atualiza a tabela Testes
    UPDATE Testes
    SET Codigo_Resultado = @codigoResultado,
        Data_Teste = @dataTeste
    WHERE ID_Produto = @id_Produto;
    
    -- Recalcula os valores para Custos_Peca (mesma lógica da trigger)
    DECLARE @tipo CHAR(2) = LEFT(@codigoPeca, 2);
    DECLARE @custoProducao DECIMAL(10,2),
            @valorVenda DECIMAL(10,2),
            @prejuizo DECIMAL(10,2),
            @custoFalha DECIMAL(10,2),
            @lucro DECIMAL(10,2);
    
	--Atualizar também na tabela de Custos
	--Filtrar pelo tipo
    IF @tipo = 'aa'
    BEGIN
        SET @custoProducao = @tempoProducao * 1.9;
        SET @valorVenda = 120;
        SET @prejuizo = @tempoProducao * 0.9;
    END
    ELSE IF @tipo = 'ab'
    BEGIN
        SET @custoProducao = @tempoProducao * 1.3;
        SET @valorVenda = 100;
        SET @prejuizo = @tempoProducao * 1.1;
    END
    ELSE IF @tipo = 'ba'
    BEGIN
        SET @custoProducao = @tempoProducao * 1.7;
        SET @valorVenda = 110;
        SET @prejuizo = @tempoProducao * 1.2;
    END
    ELSE IF @tipo = 'bb'
    BEGIN
        SET @custoProducao = @tempoProducao * 1.2;
        SET @valorVenda = 90;
        SET @prejuizo = @tempoProducao * 1.3;
    END
    ELSE
    BEGIN
        SET @custoProducao = 0;
        SET @valorVenda = 0;
        SET @prejuizo = 0;
    END

    --Determina o custo do tipo de falha com base no código do teste
    IF @codigoResultado = '01'
        SET @custoFalha = 0;
    ELSE IF @codigoResultado = '02'
        SET @custoFalha = 3;
    ELSE IF @codigoResultado = '03'
        SET @custoFalha = 2;
    ELSE IF @codigoResultado = '04'
        SET @custoFalha = 2.4;
    ELSE IF @codigoResultado = '05'
        SET @custoFalha = 1.7;
    ELSE IF @codigoResultado = '06'
        SET @custoFalha = 4.5;
    ELSE
        SET @custoFalha = 0;
    
    SET @prejuizo = @prejuizo + @custoFalha;
    SET @lucro = @valorVenda - (@custoProducao + @prejuizo);

    -- Atualiza o registro na tabela Custos_Peca na base Contabilidade
    UPDATE Contabilidade.dbo.Custos_Peca
    SET Codigo_Peca = @codigoPeca,
        Tempo_Producao = @tempoProducao,
        Custo_Producao = @custoProducao,
        Lucro = @lucro,
        Prejuizo = @prejuizo
    WHERE ID_Produto = @id_Produto;
    
    SELECT 'Produto, Testes e Custos atualizados com sucesso' AS Mensagem;
END;