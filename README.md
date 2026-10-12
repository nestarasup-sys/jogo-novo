# Estado atual — protótipo inicial validado localmente

**Escopo prioritário aprovado:** quarto da princesa → mini corredor → jardim. A porta inferior do corredor leva ao jardim e a superior retorna ao quarto. A localização é provisória, sem lore.

O protótipo está implementado em `scenes/maps/{bedroom,corridor,garden}.tscn`, `scripts/{game,player,prototype_map,prototype_hud,mobile_controls}.gd` e `tests/smoke.gd`. Em 12/10/2026, importação, abertura headless e smoke foram validados com Godot 4.7.2; o percurso, colisões, janelas e toques simultâneos estão cobertos pelo teste. **Android ainda precisa de exportação e teste em aparelho físico.** Veja [o relatório M1](docs/M1_PLAYABLE.md).

**Para jogar no Windows:** dê duplo clique em `Jogar.lnk` para abrir a cena inicial diretamente no Godot 4.7.2, sem janela de CMD. `Jogar.bat` também inicia o jogo; o CMD fecha depois de encaminhar a execução ao Godot.

Leia primeiro [docs/M1_PLAYABLE.md](docs/M1_PLAYABLE.md), [docs/PALACE_WORLD.md](docs/PALACE_WORLD.md) e [AGENTS.md](AGENTS.md). Abaixo há planejamento anterior, que **não autoriza implementar romance, NPCs, calendário ou história agora**.

---

# Jogo Novo — RPG social de fantasia imperial (pré-produção)

> **Estado:** planejamento de gameplay + protótipo mecânico inicial. Há uma pequena experiência de movimentação e interação funcional; ainda **não existe demo narrativa**. Nome provisório; história/lore **não definidos**.

Jogo 2D top-down para **Windows e Android horizontal**. A protagonista é uma **princesa imperial**, vivendo no palácio de uma ambientação de fantasia aristocrática inspirada no *gênero* de manhwas de romance. O jogo mistura exploração/rotina social com diálogos, escolhas e romances complexos. Referências: *Stardew Valley* (exploração/rotina) e *Amor Doce* (narrativa/romances). **Não reproduzir personagens, roteiro nem assets** dessas obras.

## O que foi decidido
- Protagonista: princesa imperial; a **história, biografias, mundo e lore serão criados depois pelo diretor criativo**.
- Mundo 2D explorável, NPCs com rotina, ações/interações e diálogos com escolhas.
- Dias livres **separados** de capítulos narrativos condicionais.
- Relações com consequências, conflitos e finais alternativos.
- Windows + Android em paisagem; controles teclado e toque.
- Godot 4.x/GDScript; versão exata a fixar quando começar implementação/testes; resolução de design 1280×720 como base proposta.
- Codex implementará a programação; as decisões criativas são do criador.

## Proposta de recorte jogável (sujeita a ajustes)
Uma primeira experiência **inteiramente dentro do palácio**, dividida em três áreas de navegação:
1. **Ala privada:** quarto da princesa, gabinete/closet (esboços de cômodos).
2. **Ala social:** corredores e salas de convivência.
3. **Jardins imperiais:** encontros e exploração ao ar livre.

Os três nomes acima são **organização provisória do protótipo**, não mapa definitivo. A capital, academia e outras regiões ficam para avaliação futura. O protótipo deve demonstrar exploração, mudança de período, três NPCs provisórios, conversa com escolhas, um evento ramificado neutro e save/load, **sem exigir lore ou personagens canônicos**.

## Documentos
- [Decisões com status](docs/DECISIONS.md)
- [Visão de design](docs/GAME_DESIGN.md)
- [Mecânicas e loop de gameplay](docs/GAMEPLAY_SYSTEMS.md)
- [Organização proposta do palácio](docs/PALACE_WORLD.md)
- [Escopo da versão 0.1](docs/PROTOTYPE_01.md)
- [Arquitetura](docs/ARCHITECTURE.md)
- [Dados narrativos](docs/CONTENT_SCHEMA.md)
- [Roadmap](docs/ROADMAP.md)
- [Dúvidas em aberto](docs/OPEN_QUESTIONS.md)
- [Plano de testes](docs/TEST_PLAN.md)
- [Orientações ao Codex](AGENTS.md)

## Estado técnico
O projeto, as três cenas, movimento, colisões, interação e portas foram validados em execução headless no Godot 4.7.2. Arte final, conteúdo narrativo e demais sistemas seguem fora deste protótipo. Não há validação de APK ou aparelho Android. Arquivos em `content/` são **exemplos fictícios de schema, não lore**.

## Procedimento
Discussão criativa → classificar em **decidido / proposta / adiado** → atualizar docs → tarefa isolada no Codex → testes → validar com o diretor criativo. Não confundir inspiração de outros jogos com reprodução de material protegido.
