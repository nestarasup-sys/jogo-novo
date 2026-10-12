# Fluxo de trabalho ChatGPT + Codex + GitHub

## Papéis
**Diretor criativo:** decide escopo, avalia resultado jogável, aprova mudanças de prioridade, lore e personagens. **ChatGPT:** propõe arquitetura e tarefas pequenas, revisa consistência de documentação e requisitos. **Codex:** implementa em branch, executa os testes disponíveis e publica mudanças para revisão.

## Ciclo de cada tarefa
1. Ler primeiro `AGENTS.md`, `README.md`, `docs/PROJECT_HUB.md` e `docs/M1_PLAYABLE.md`.
2. Checar branch, PRs e arquivos atuais antes de editar. Não sobrescrever trabalho recente.
3. Selecionar **um objetivo verificável**, declarar explicitamente o que fica fora do escopo.
4. Implementar com mudanças pequenas, sem inventar conteúdo canônico.
5. Validar importação Godot, execução headless e smoke tests; testar manualmente no Windows quando aplicável.
6. Abrir PR descrevendo: mudanças, como testar, resultados, riscos e limitações.
7. Integrar somente após conferir a branch-alvo e eventuais conflitos. Nunca forçar push ou apagar histórico para fazer merge.
8. Atualizar documentação factual e decisões somente quando houver mudança aprovada.

## Definição de pronto — M1
- Iniciar no quarto.
- Passar quarto → corredor → jardim e retornar sem ficar preso.
- Colisões, movimento e interações funcionam no Windows.
- Projeto abre na versão Godot documentada, sem erros bloqueantes.
- Smoke test passa; limitações ficam registradas.

## Regras de segurança e qualidade
- Preservar trabalhos do diretor criativo e de outros agentes.
- Não colocar segredos, credenciais ou arquivos gerados no Git.
- Não alegar teste em aparelho físico sem evidência.
- Não implementar Android enquanto a instrução vigente for Windows primeiro.
- Separar ideias/propostas de decisões firmes e código efetivamente concluído.

## Próximas fases candidatas (precisam de autorização)
M2: interação consistente e HUD no trio de mapas; M3: primeiro NPC placeholder; M4: sistema mínimo de diálogo; M5: estado e save; M6: calendário/rotina; M7: capítulos e relacionamento; M8: expansão e Android ao final.

A ordem é sugestão de engenharia e pode mudar com novas decisões do diretor criativo.
