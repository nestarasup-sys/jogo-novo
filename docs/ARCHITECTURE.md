> **ATUALIZAÇÃO DE ESCOPO (12/10/2026):** a etapa atualmente autorizada é SOMENTE testar e corrigir os controles de **quarto → mini corredor → jardim**. A porta inferior do corredor conduz ao jardim. A cena inicial é o quarto da princesa. Código inicial em `scenes/maps/`, `scripts/game.gd`, `player.gd`, `prototype_map.gd`, `prototype_hud.gd`, `mobile_controls.gd`, e teste `tests/smoke.gd`. **Ainda não foi executado na Godot**. O Codex deve importar, validar, testar e consertar, sem adicionar NPC, história, capítulos, tempo ou romances. Consultar [M1_PLAYABLE.md](M1_PLAYABLE.md). Todas as ideias abaixo são backlog de longo prazo, não tarefas desta rodada.

---

# Arquitetura técnica — design proposto, não runtime concluído

## Objetivo
Apoiar mundo 2D do palácio, dias livres e eventos narrativos sem acoplar lógica de história à cena do mapa. O gênero foi alterado para **fantasia imperial**; lore e elenco serão definidos posteriormente.

## Camadas
1. **Visual:** Godot `scenes/`, UI, movimento, mapas e NPC visuais.
2. **Aplicação:** GameRoot, relógio, regras de interação, NPCs, eventos, capítulos, diálogos.
3. **Domínio:** estado, condições e efeitos (testáveis sem cena).
4. **Dados/persistência:** content JSON validado; save local versionado em `user://`.

## Serviços
| Serviço | Papel |
|---|---|
| GameRoot | Montar cena atual e inicializar serviços |
| GameState (Autoload) | Armazenar estado global serializável |
| GameEvents (Autoload) | Sinais de evento; sem regras de negócio |
| WorldController | Mapas, portais e spawns entre as alas |
| InteractionService | Encontrar alvo mais apropriado e despachar intenção `interact` |
| WorldClock | Dia e períodos; não altera capítulos automaticamente |
| NpcScheduleService | Definir onde cada NPC aparece por período |
| ContentRepository | Carregar JSON, validar IDs, conexões e referências |
| DialogueController | Exibir diálogo, opções e solicitar aplicação de efeitos |
| RelationshipService | Stats/estados de vínculos por NPC e flags associadas |
| EventDirector | Checar condições, prioridade, gatilhos e duplicidade |
| ChapterManager | Marcos obrigatórios, liberações e mudança de capítulo |
| SaveService | Snapshot, validação, escrita atômica e migração |

**Extensões propostas, não implementar agora:** `CourtReputationService`, `CorrespondenceService`, `WardrobeService`, `AccessPolicyService`. O protótipo só necessita de um mecanismo simples de portas/condições, sem sistemas políticos.

## Fluxo de escolha
UI → DialogueController recebe `choice_id` → valida estado/condições → resolve efeitos permitidos → RelationshipService/GameState aplicam atomically → marca escolha/evento processado → emite sinais → UI atualiza. Nenhum efeito deve repetir após load.

## Temporalidade
`day` inteiro, `period` ∈ morning/afternoon/evening. Relógio muda por comandos explícitos e comunica alteração à agenda. Capítulo depende de milestones/condições independentes de quantidade de dias.

## Mapa e dados
IDs provisórios de área: `private_wing`, `social_wing`, `imperial_gardens`. Prefira uma cena por macroárea com marcadores de portas/spawn; interiores menores podem ser subcenas futuramente. IDs salvos devem permanecer estáveis depois da primeira release.

## Estado mínimo do save
`save_version`, `player_name`, `day`, `period`, `map_id`, `spawn_or_position`, `chapter_id`, `chapter_milestones`, `relations`, `flags`, `completed_events`, `applied_choices`. Reputação e correspondência entram só quando aprovadas.

## Integridade
- Conditions whitelist: `all`, `any`, `stat_gte`, `flag_equals`, `event_completed`, `chapter_equals`, `period_equals`; desconhecido = erro.
- Effects whitelist: `adjust_stat`, `set_flag`, `complete_event`, `complete_milestone`.
- Events classificados por prioridade + ID estável (desempate).
- Não usar `eval`, strings executáveis nem referências diretas de Node em saves.
- Scripts de UI não alteram stats ou marcos sem serviço intermediário.

## Windows / Android
Godot 4.x GDScript, renderizador Compatibility inicialmente, viewport 1280×720 como design, interface em landscape, espaço seguro, InputMap comum, joystick virtual. Conferir requisitos de export e preservar JSON no bundle. Configuração deve ser validada no dispositivo real.

## Testes
Domínio headless: condições, idempotência, limites, milestones, save/load, conteúdo. Testes manuais: colisão, transição entre alas, NPCs por horário, HUD e toque. Ver `TEST_PLAN.md`.

## Pendências
Versão de patch Godot, estilo de arte, desempenho Android e granularidade de cena. Documentos de design **não são evidência de implementação**.
