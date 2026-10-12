# Regras para Codex e outros agentes

Leia `README.md`, `docs/GAME_DESIGN.md`, `docs/ARCHITECTURE.md`, `docs/PROTOTYPE_01.md` e `docs/CONTENT_SCHEMA.md` antes de alterar código.

## Regras inegociáveis
1. Não confunda **proposta/documentação** com implementação concluída.
2. Trabalhe em entregas pequenas; não implemente todo o jogo numa única mudança.
3. Priorize Godot 4.x/GDScript tipado, código legível e arquitetura de baixa dependência.
4. No estágio inicial, somente `GameState` e `GameEvents` podem ser Autoloads; outros sistemas devem ter ciclo de vida explícito.
5. Evite dependências circulares, scripts monolíticos e lógica de capítulo hardcoded em mapas.
6. JSON de conteúdo é **dado**, nunca código; não usar `eval` nem execução dinâmica; validar tipos, IDs e referências.
7. Uma escolha não pode aplicar efeitos duas vezes; eventos precisam de IDs e ordem determinística.
8. O calendário não faz capítulos avançarem automaticamente. Eventos opcionais não podem causar softlocks.
9. Saves devem ser versionados, validados e compatíveis com futuras migrações; escrever com segurança.
10. Todo sistema novo precisa de teste reproduzível e documentação atualizada.
11. Testar Windows e Android separadamente. Não alegar testes no Android físico sem dispositivo real.
12. Nunca adicionar imagens, fontes, áudios ou dependências sem licença conhecida; não copiar assets de jogos de referência.
13. Preservar decisões aprovadas pelo criador e registrar mudanças de escopo em documentos.
14. Priorizar acessibilidade: legibilidade, navegação touch/teclado, áreas seguras Android.

## Conclusão de cada tarefa
Informar resumo, arquivos alterados, comandos executados, testes aprovados/falhos, limitações e próximo passo. Se Godot/Android SDK não estiverem disponíveis, declarar que os testes relevantes **não foram executados**.

## Ordem recomendada
Fundação e movimento → mapas/transições → relógio/rotina → diálogos/JSON → relacionamentos e eventos → capítulos → save/load → UI touch → exports e testes reais. Ver `docs/ROADMAP.md`.

## Padrões
- Código, IDs e caminhos: inglês consistente (snake_case em dados/arquivos; classes conforme padrões Godot).
- Textos voltados ao jogador e docs: português do Brasil.
- Novos eventos/rotas adicionados via dados usando o schema documentado.
- Nunca inserir segredos, tokens, keystores ou credenciais no Git.
