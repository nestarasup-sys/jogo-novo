# Protótipo 0.1 — Palace Social Slice

**Status:** escopo mecânico proposto para validação pelo criador. Sem lore canônica ou personagens finais.

## Hipótese a testar
É divertido explorar um palácio, seguir rotinas de NPCs, escolher respostas e lidar com consequências **sem depender de cenas roteirizadas lineares o tempo todo**?

## Recorte
- **3 cenas/macroáreas provisórias:** `private_wing` (começando no quarto da princesa), `social_wing`, `imperial_gardens`; conectadas, com colisões.
- **Protagonista princesa imperial:** identificação narrativa genérica, nome editável se aprovado; **não definir biografia, família ou trama**.
- **3 NPCs de teste anônimos:** aparências provisórias, cronograma simples e diálogos neutros; não são elenco.
- **Dias livres:** manhã/tarde/noite, avançados pelo jogador e pelo descanso.
- **Diálogos:** retrato temporário, falas, escolhas e variáveis persistentes.
- **Uma cena de teste ramificada:** por exemplo, um pedido de ajuda rotineiro em um dos jardins; duas escolhas e dois resultados diferentes, **sem implicações de lore**.
- **Relações:** protótipo de afinidade/confiança/romance/conflito com pelo menos duas variáveis realmente usadas em condições.
- **Capítulos:** fase/capítulo de teste que só avança após flag, nunca automaticamente por dias.
- **Save/load:** dia, período, mapa, posição, flags, capítulo, eventos concluídos e relações.
- **UI:** HUD dia/período, interação, diálogo, menu; teclado e layout landscape/touch previstos.

## Experiência demonstrada
1. Protagonista aparece nos aposentos.
2. Anda até a ala social e encontra NPC.
3. Avança período e vê rotina de NPC mudar.
4. Chega aos jardins e encontra evento com duas escolhas.
5. Cada escolha altera estado e uma conversa seguinte reage.
6. Dorme, passa outro dia, sem pular capítulo arbitrariamente.
7. Salva, fecha, carrega e mantém tudo.

## Critérios de aceite
- Zero transições para coordenadas inválidas; 3 áreas acessíveis de ida/volta.
- Pelo menos um NPC muda de local por período; ausência não deixa interação invisível.
- Sem diálogo permitir mover jogador ou avançar período.
- Alterações de stats e flags aplicadas uma vez por choice instance/event.
- Duas resoluções distintas alcançáveis a partir de um mesmo save-base.
- Eventos obrigatórios recuperáveis caso uma janela temporal tenha passado.
- Save/load round-trip válido e corrupção tratada com erro legível.
- Testes automatizados do domínio; builds testadas em Windows e Android por etapas, sem afirmar que foram executadas antes disso.

## Não escopo
História oficial, rota romântica completa, monarquia/família, capital, escolas, agricultura, combate, dinheiro, roupas complexas, reputação sistêmica e correio completo.

## Ordem
M1 base+movimento; M2 mapa+interação; M3 período+NPC; M4 diálogo+conteúdo; M5 relações+evento/capítulo neutro; M6 save; M7 toque/export; M8 QA. Ver `ROADMAP.md`.
