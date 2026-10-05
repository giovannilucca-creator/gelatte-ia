import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const _model = 'gemini-3.6-flash';

  static Future<String> analisar({
    required double receita,
    required double despesas,
    required double lucro,
    required double margem,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('Chave da IA não configurada. Execute com --dart-define=GEMINI_API_KEY=SUA_CHAVE');
    }

    final uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent');
    final prompt = '''Você é um assistente financeiro para uma pequena sorveteria chamada Gelatte.
Analise os indicadores abaixo e responda em português do Brasil, de forma objetiva e profissional.
Receita: R\$ ${receita.toStringAsFixed(2)}
Despesas: R\$ ${despesas.toStringAsFixed(2)}
Lucro: R\$ ${lucro.toStringAsFixed(2)}
Margem: ${margem.toStringAsFixed(1)}%

Forneça: 1) diagnóstico em 2 frases; 2) dois pontos de atenção; 3) três ações práticas. Não invente dados.''';

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'x-goog-api-key': _apiKey},
      body: jsonEncode({
        'contents': [
          {'parts': [{'text': prompt}]}
        ]
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Falha na IA (${response.statusCode}). ${response.body}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) throw Exception('A IA não retornou conteúdo.');
    final parts = candidates.first['content']?['parts'] as List?;
    if (parts == null || parts.isEmpty) throw Exception('Resposta da IA vazia.');
    return (parts.first['text'] as String?)?.trim() ?? 'Resposta vazia.';
  }
}
