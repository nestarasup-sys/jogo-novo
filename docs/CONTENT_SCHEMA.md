# Contratos preliminares de conteúdo

**Status: proposta de v1, a implementar pelo Codex.** Todos os arquivos UTF-8; IDs únicos e estáveis em snake_case. Alterar schema exige versão/migração.

## Convenção
- `characters/*.json`: ID, nome, stats iniciais, metadados visuais.
- `dialogues/*.json`: conjunto de nós e escolhas.
- `events/*.json`: localização, prioridade, condições, referência a diálogo.
- `schedules/*.json`: NPC, período, local e spawn.
- `chapters/*.json`: marcos e critérios de conclusão.

### Exemplo de evento
```json
{
  "schema_version": 1,
  "id": "lia_praca_intro",
  "chapter": "chapter_01",
  "location": "square",
  "priority": 100,
  "conditions": {
    "all": [
      {"type": "period_equals", "value": "afternoon"},
      {"type": "flag_equals", "flag": "lia_met", "value": false}
    ]
  },
  "dialogue_id": "lia_intro"
}
```

### Exemplo de diálogo
```json
{
  "schema_version": 1,
  "id": "lia_intro",
  "start_node": "start",
  "nodes": {
    "start": {
      "speaker": "lia",
      "text": "Eu gosto de vir aqui para pensar.",
      "choices": [
        {
          "id": "stay",
          "text": "Posso ficar com você?",
          "effects": [
            {"type": "adjust_stat", "character": "lia", "stat": "affinity", "delta": 5},
            {"type": "set_flag", "flag": "lia_met", "value": true}
          ],
          "next": "end"
        },
        {
          "id": "leave",
          "text": "Talvez em outro momento.",
          "effects": [{"type": "set_flag", "flag": "lia_met", "value": true}],
          "next": "end"
        }
      ]
    },
    "end": {"speaker": "lia", "text": "Até mais.", "end": true}
  }
}
```

## Regras do interpretador
- Comparações explícitas; operadores desconhecidos são erro de validação.
- Estatísticas limitadas a [0,100]; estados relacionais são enums explícitos.
- `choice_id` é único dentro do diálogo; efeitos aplicados uma vez por instância narrativa registrada.
- Erros de referência (personagem, diálogo, evento, capítulo, node) identificados antes de rodar.
- IDs não são texto mostrado ao jogador; tradução futura deverá referenciar chaves estáveis.
- Dados de exemplo NÃO garantem que o runtime já os processe.

Ver exemplos em `content/`.
