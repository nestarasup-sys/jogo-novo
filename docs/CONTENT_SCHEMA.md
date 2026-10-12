# Schema provisório de conteúdo (v1, ainda não implementado)

Todos os arquivos são dados JSON UTF-8; IDs em snake_case imutáveis quando usados em saves. Exemplo genérico **não representa lore nem NPC definitivo**.

## Pastas previstas
- `content/characters/*.json`: NPCs e stats iniciais.
- `content/dialogues/*.json`: textos, nós e choices.
- `content/events/*.json`: gatilhos, prioridades e condições.
- Futuras: `content/schedules/`, `content/chapters/`, `content/locations/`, `content/letters/` **somente se implementadas**.

## Referência simples de personagem
```json
{
  "schema_version": 1,
  "id": "sample_attendant",
  "prototype_only": true,
  "display_name": "Pessoa de teste",
  "initial_stats": {"affinity": 0, "trust": 0, "romance": 0, "conflict": 0},
  "relationship_state": "acquaintances"
}
```

## Referência de evento
```json
{
  "schema_version": 1,
  "id": "sample_garden_meeting",
  "prototype_only": true,
  "chapter": "chapter_test",
  "location": "imperial_gardens",
  "priority": 100,
  "conditions": {"all": [
    {"type": "period_equals", "value": "afternoon"},
    {"type": "flag_equals", "flag": "sample_meeting_done", "value": false}
  ]},
  "dialogue_id": "sample_garden_dialogue"
}
```

## Referência de diálogo
```json
{
  "schema_version": 1,
  "id": "sample_garden_dialogue",
  "prototype_only": true,
  "start_node": "start",
  "nodes": {
    "start": {
      "speaker": "sample_attendant",
      "text": "Poderia me ajudar com uma tarefa?",
      "choices": [
        {"id": "help", "text": "Posso ajudar.", "effects": [
          {"type": "adjust_stat", "character": "sample_attendant", "stat": "trust", "delta": 5},
          {"type": "set_flag", "flag": "sample_meeting_done", "value": true}
        ], "next": "end"},
        {"id": "decline", "text": "Agora não posso.", "effects": [
          {"type": "set_flag", "flag": "sample_meeting_done", "value": true}
        ], "next": "end"}
      ]
    },
    "end": {"speaker": "sample_attendant", "text": "Entendido.", "end": true}
  }
}
```

## Contratos/validações que o Codex implementará
- `schema_version` explícito; IDs não duplicados e todas referências resolvidas.
- Opções possuem `id` único no diálogo; choices geram instância com chave idempotente.
- Stats limitadas a 0–100; valores fora do limite são clamp ou erro com teste documentado.
- Whitelist de condições e efeitos (ver `ARCHITECTURE.md`); não aceitar `eval`/código arbitrário.
- Erro de referência faltante encerra carregamento do evento em modo de desenvolvimento.
- Texto de UI em pt-BR, IDs técnicos inglês.
- Extensões como reputação, cartas/vestidos são propostas e não entram no schema v1 automaticamente.

**Importante:** estes documentos e arquivos `.example.json` são exemplos de design; o jogo ainda não tem parser/validador de JSON funcional.
