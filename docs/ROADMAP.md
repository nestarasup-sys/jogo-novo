# Roadmap de implementação — jogo de palácio

**Não iniciado**, exceto bootstrap/documentação. Cada marco deve ser revisado e testado antes de avançar. O conteúdo do exemplo nunca é lore canônica.

- [ ] **M1 Fundação:** abrir/importar Godot, criar GameRoot, personagem top-down, input keyboard, colisões, cena de teste, testes headless.
- [ ] **M2 Exploração do palácio:** `private_wing`, `social_wing`, `imperial_gardens` provisórios, portas bidirecionais, interação contextual.
- [ ] **M3 Rotina diária:** WorldClock manhã/tarde/noite, descanso e agenda básica de NPCs.
- [ ] **M4 Narrativa genérica:** JSON validado, UI retratos/opções, EventDirector.
- [ ] **M5 Consequências:** RelationshipService, condições por stats/flags, capítulo de teste e escolhas com 2 resoluções.
- [ ] **M6 Save/load:** versionamento, idempotência, fallback de corrupção e testes.
- [ ] **M7 Mobile + exports:** interface responsiva, controles touch, export Windows, APK Android landscape.
- [ ] **M8 Qualidade:** regressão, UX, legibilidade, controle de erros e testes em hardware real.

## Trilhas opcionais (NÃO implementadas)
- Reputação imperial/rumores.
- Correspondências, convites e agenda.
- Vestuário/etiqueta.
- Regiões além do palácio.
- Diário de escolhas e histórico de diálogos.
- Personalização estética e conteúdo narrativo canônico.

## Próxima tarefa técnica
Somente M1, **quando o criador autorizar**. Neste momento a prioridade é design/gameplay, não preencher enredo.
