import json
from java.net import URL, HttpURLConnection
from java.io import BufferedReader, InputStreamReader, OutputStreamWriter
import time, re
import sys

def enviarDadosProducao(producao):
    #URL da API REST
    apiUrl = "http://localhost:7185/api/Producao"
    
    #Muda o objeto 'producao' para JSON
    json_data = json.dumps(producao)
    
    try:
        #Cria a conexão HTTP
        url = URL(apiUrl)
        conn = url.openConnection()
        conn.setDoOutput(True)  #Permite envio de dados
        conn.setRequestMethod("POST")
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8")
        
        #Escreve os dados JSON no corpo da requisição
        os = conn.getOutputStream()
        writer = OutputStreamWriter(os, "UTF-8")
        writer.write(json_data)
        writer.flush()
        writer.close()
        os.close()
        
        #Recupera o código de resposta HTTP
        responseCode = conn.getResponseCode()
        
        #Verifica se a resposta foi bem-sucedida (HTTP 200 ou 201)
        if responseCode == 200 or responseCode == 201:
            reader = BufferedReader(InputStreamReader(conn.getInputStream(), "UTF-8"))
            response = ""
            line = reader.readLine()
            while line is not None:
                response += line
                line = reader.readLine()
            reader.close()
            print("Dados enviados com sucesso: " + response + "\n")
        else:
            #Lê a mensagem de erro se a resposta não foi de sucesso
            reader = BufferedReader(InputStreamReader(conn.getErrorStream(), "UTF-8"))
            errorResponse = ""
            line = reader.readLine()
            while line is not None:
                errorResponse += line
                line = reader.readLine()
            reader.close()
            print("Erro ao enviar dados: " + str(responseCode) + " - " + errorResponse + "\n")
    except Exception as ex:
        print("Exceção durante a comunicação com a API: " + str(ex) + "\n")

# Localiza a região da tela onde os dados são exibidos, usando o padrão como referência.
try:
    consoleRegion = find(Pattern("1743089860643.png").targetOffset(-351, -187))
except FindFailed:
    print "Padrão não encontrado na tela."
    exit(1)

while True:
    #Extrai o texto da região encontrada
    textoConsole = consoleRegion.text()
    
    #Verifica se o texto existe e contém o delimitador ";"
    if textoConsole and ";" in textoConsole:
        
        #Realiza um triplo clique para selecionar o texto todo
        consoleRegion.click()
        mouseDown(Button.LEFT)
        mouseUp(Button.LEFT)
        wait(0.01)
        mouseDown(Button.LEFT)
        mouseUp(Button.LEFT)

        time.sleep(1) 
        
        #Copia o texto selecionado (Ctrl+C)
        type("c", KEY_CTRL)
        time.sleep(1)  
        
        #Recupera o texto da área de transferência
        textoCopiado = Env.getClipboard()
        if textoCopiado and re.search(r"\d{4}-\d{2}-\d{2}", textoCopiado):
            #Divide os campos removendo espaços em branco e descartando campos vazios
            data, hora, codigo, tempo, resultado = [s.strip() for s in textoCopiado.split(";") if s.strip() != ""]
            print "Data:", data
            print "Hora:", hora
            print "Código da Peça:", codigo
            print "Tempo de Produção:", tempo
            print "Resultado do Teste:", resultado

            #Monta o objeto de produção com os dados extraídos
            producao = {
                "CodigoPeca": codigo,
                "DataProducao": data,
                "HoraProducao": hora,
                "TempoProducao": int(tempo),
                "CodigoResultado": resultado,
                "DataTeste": data
            }
            
            #Chama a função de envio via API REST
            enviarDadosProducao(producao)
        else:
            print "Texto copiado não está no formato esperado:", textoCopiado
        
        #Aguarda o tempo mínimo de produção
        time.sleep(10)
    else:
        # Aguarda antes de tentar novamente
        time.sleep(1)