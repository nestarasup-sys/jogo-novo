# Roadmap para Codex

Cada fase requer PR pequeno, checklist de critérios e evidência de testes. Não marcar como concluído só por adicionar arquivos.

- [ ] **M1 Fundação:** projeto, GameRoot, input, personagem movimentável, colisão, documentação e validação headless.
- [ ] **M2 Mundo:** casa/praça/escola, transições, spawn, NPCs simples.
- [ ] **M3 Tempo:** dias, três períodos, rotinas NPC e controles de avanço.
- [ ] **M4 Narrativa:** ContentRepository, schemas/validação, DialogueController, UI, EventDirector.
- [ ] **M5 Relações e capítulos:** stats, estados, flags, milestones, conflito de Lia e 2 resoluções.
- [ ] **M6 Save/load:** persistência versionada, recuperação de erro, idempotência e testes.
- [ ] **M7 Plataformas:** inputs touch, HUD safe areas, presets, Windows e Android.
- [ ] **M8 Qualidade:** regressão, perfis de dispositivos, correções de UI, builds testadas.

## Próxima tarefa recomendada
Implementar apenas **M1**. Não avançar sozinho para M2. Conferir versão de manutenção Godot instalada e registrar no README; criar controlador do jogador, input e uma cena de teste com colisão, seguida de testes em linha de comando.
