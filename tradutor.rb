require 'net/http'
require 'json'

class Tradutor

  def iniciar
    puts "Digite o texto:"
    texto_original = gets.chomp

    puts "Qual o idioma de origem? (ex: pt)"
    idioma_origem = gets.chomp

    puts "Para qual idioma deseja traduzir? (ex: en)"
    idioma_destino = gets.chomp

    texto_traduzido = traduzir(texto_original, idioma_origem, idioma_destino)
    puts "\nTexto traduzido:"
    puts texto_traduzido

    salvar(texto_original, texto_traduzido)
  end


  def traduzir(texto_original, idioma_origem, idioma_destino)
    uri = URI("https://libretranslate.de/translate")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["User-Agent"] = "Ruby Translator"

    request.body = {
      q: texto_original,
      source: idioma_origem,
      target: idioma_destino,
      format: "text"
    }.to_json

    response = http.request(request)

    resultado = JSON.parse(response.body)
    resultado["translatedText"]
  end


  def salvar(texto_original, texto_traduzido)
    File.open("traducoes.txt", "a") do |arquivo|
      arquivo.puts "Texto original: #{texto_original}"
      arquivo.puts "Texto traduzido: #{texto_traduzido}"
      arquivo.puts "-" * 50
    end
  end

end

Tradutor.new.iniciar
