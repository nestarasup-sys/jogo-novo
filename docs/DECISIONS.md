> **ESPECIALIZAÇÃO ATUAL — TEXTURAS E ESCALA (2026-10-12):** com a integração da princesa via PR #2 e validação anterior do protótipo, iniciar exclusivamente a aplicação da textura do chão e parede **no quarto** e aplicar **Camera2D zoom 1.30× no mundo inteiro**. Isso amplia visualmente a princesa, móveis e cenários sem redimensionar hitboxes ou alterar velocidades. Câmera segue protagonista e fica limitada ao mapa. A interface CanvasLayer mantém escala normal. A folha de móveis será recortada **mais adiante**. Windows continua prioritário; Android no final. Ver [M2_BEDROOM_TEXTURE_ZOOM.md](M2_BEDROOM_TEXTURE_ZOOM.md).\n\n---\n\n> **DECISÃO CONFIRMADA — 12/10/2026:** foco de desenvolvimento e testes será **Windows**. Android, embora objetivo futuro, será trabalhado **somente na fase final**. O usuário testou o protótipo inicial e confirmou que funciona. Codex publicou o [PR #1](https://github.com/nestarasup-sys/jogo-novo/pull/1) numa branch para revisão/merge. A implementação atual segue restrita a quarto, corredor e jardim, movimento, colisão e interação. Lore permanece adiada.

---

> **ATUALIZAÇÃO DE ESCOPO (12/10/2026):** a etapa atualmente autorizada é SOMENTE testar e corrigir os controles de **quarto → mini corredor → jardim**. A porta inferior do corredor conduz ao jardim. A cena inicial é o quarto da princesa. Código inicial em `scenes/maps/`, `scripts/game.gd`, `player.gd`, `prototype_map.gd`, `prototype_hud.gd`, `mobile_controls.gd`, e teste `tests/smoke.gd`. **Ainda não foi executado na Godot**. O Codex deve importar, validar, testar e consertar, sem adicionar NPC, história, capítulos, tempo ou romances. Consultar [M1_PLAYABLE.md](M1_PLAYABLE.md). Todas as ideias abaixo são backlog de longo prazo, não tarefas desta rodada.

---

# Registro de decisões — 2026-10-12

Este documento impede que sugestões sejam tratadas como fatos canônicos. **DECIDIDO** = afirmado pelo criador; **PROPOSTO** = sugestão de design ainda ajustável; **ADIADO** = deliberadamente não definir agora.

## DECISÃO MAIS RECENTE: primeiro quarto + mini corredor + jardim, controles e interação (sem lore).\n\n## DECIDIDO
| Tema | Decisão |
|---|---|
| Gênero | Jogo social de exploração com romances profundos, escolhas e consequências |
| Referência estética | Fantasia imperial/aristocrática do gênero manhwa de romance |
| Protagonista | Princesa imperial; idade e história pessoal a definir |
| Mundo | Interiores do palácio, incluindo quarto/aposentos da protagonista |
| Ritmo | Dias livres + capítulos narrativos condicionais |
| Romance | Conflitos, ramificações e múltiplos finais |
| Plataformas | Windows e Android em orientação horizontal |
| Processo | Criador decide gameplay/lore; ChatGPT + Codex auxiliam na arquitetura e programação |
| Prioridade atual | **Discutir e projetar mecânicas/gameplay**; escrita de lore depois |

## PROPOSTO (não canônico / não automaticamente aprovado para implementação)
| Tema | Hipótese de design |
|---|---|
| Recorte de mundo V0.1 | Três áreas do palácio: ala privada, ala social, jardins |
| Relógio MVP | Manhã/tarde/noite, sem contagem contínua de minutos |
| Sistema social | Afinidade, confiança, romance e conflito; estado de relação |
| Corte | Reputação pública e rumores independentes dos relacionamentos |
| Correspondências | Cartas, convites e respostas pela escrivaninha do quarto |
| Guarda-roupa | Trajes como expressão/etiqueta com eventos, sem monetização |
| Acesso | Salas abertas/bloqueadas por regras sociais e marcos narrativos |
| Conteúdo de teste | NPCs anônimos e eventos genéricos, sem história oficial |
| Stack | Godot 4.x/GDScript, Compatibility, resolução de design 1280x720 |
| Save | Progresso local, schema versionado, slots a definir |

## ADIADO
Nome oficial, império e história, origem de conflitos, família imperial, aliados, interesses românticos, elenco, roteiro e finais específicos, arte final (pixel art vs ilustrada), classificação indicativa e mapa completo do reino.

## REVOGADO como história proposta
O roteiro "A Segunda Coroa" e a personagem Lia eram apenas **exemplos improvisados**; não servem de base canônica e não entram no protótipo atual.

## Regra de atualização
Nova decisão só vira **DECIDIDO** quando o criador disser que aprovou. Sugestões e exemplos permanecem em **PROPOSTO**.
