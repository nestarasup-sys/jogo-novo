# Arquitetura técnica proposta (não totalmente implementada)

## Camadas
1. **Presentação:** cenas Godot (mapas, personagem, NPC, HUD, diálogo, menu).
2. **Aplicação:** serviços coordenam ações: relógio, eventos, diálogos, capítulos e relações.
3. **Domínio:** estado serializável, regras puras e resultados de escolhas.
4. **Dados:** JSON versionado/validado e persistência em `user://`.

## Responsabilidades
| Módulo | Responsabilidade |
|---|---|
| GameRoot | Compor e controlar ciclo de vida dos serviços/cenas |
| GameState (Autoload) | Fonte de verdade do estado serializável |
| GameEvents (Autoload) | Sinais de ações e transições, sem armazenar lógica |
| WorldClock | Dia + período; não gerencia capítulo |
| ChapterManager | Marcos obrigatórios, avanço por condições |
| DialogueController | Exibir nós, opções, selecionar respostas e pedir aplicação de efeitos |
| RelationshipService | Estatísticas [0,100], estado e regras de relação |
| EventDirector | Avaliar elegibilidade/prioridade e disparar cenas |
| NpcScheduleService | Disponibilidade/posições de NPC por lugar/período |
| ContentRepository | Carregar/validar JSON, resolver referências por ID |
| SaveService | Serializar, validar, gravar e migrar saves |
| WorldController | Carregar mapas, spawn, transferência entre cenas |

## Comunicação
Serviços invocados por interfaces claras, eventos através de sinais. UI envia intenções; serviços validam regras e retornam resultado; GameState é atualizado em um único fluxo controlado. Evitar UI alterando stats diretamente.

## Estado mínimo
`save_version`, `player_name`, `chapter_id`, `chapter_milestones`, `day`, `period`, `map_id`, `position`, `relations`, `flags`, `completed_events`, `applied_choice_ids`.

## Determinismo e consistência
- Eventos: prioridade numérica, depois ID para desempate.
- Aplicação idempotente: registrar chave de efeito antes de liberar repetição; transação lógica de atualização.
- Proteger contra repetição de diálogo na mesma sessão e após reload.
- Nunca serializar NodePath/referências de cena como verdade de progresso.
- Evitar salvar em meio a transições ou aplicar parcialmente efeitos.

## Dados e segurança
- Validar schema/referências ao carregar conteúdo; rejeitar operadores não reconhecidos.
- Condições whitelist: `all`, `any`, `stat_gte`, `flag_equals`, `event_completed`, `chapter_equals`, `period_equals`.
- Efeitos whitelist: `adjust_stat`, `set_flag`, `complete_event`, `complete_milestone`.
- Nada de executar expressões dinâmicas vindas de JSON.

## Android e Windows
Design 1280×720, paisagem, controles touch adaptáveis, safe areas e navegação UI. InputMap com `move_left/right/up/down`, `interact`, `ui_cancel`. Compatibility como configuração inicial a validar. Incluir JSON nos pacotes exportados.

## Testabilidade
Regras de domínio sem dependência de cena quando possível. Testes headless para elegibilidade de eventos, idempotência, progresso de capítulo, JSON, saves; testes manuais do movimento e UX mobile.

## Decisões pendentes
Godot patch exato, esquema de escalonamento pixel-art/desenho ilustrado, política de múltiplos slots e autoria de conteúdo. Ver `OPEN_QUESTIONS.md`.
