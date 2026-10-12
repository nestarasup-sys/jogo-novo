# Estado atual — protótipo de controles

**Escopo prioritário aprovado:** quarto da princesa → mini corredor → jardim. A porta inferior do corredor leva ao jardim e a superior retorna ao quarto. A localização é provisória, sem lore.

O código já foi adicionado ao repositório: `scenes/maps/{bedroom,corridor,garden}.tscn`, `scripts/{game,player,prototype_map,prototype_hud,mobile_controls}.gd`, `tests/smoke.gd`. Movimento 8 direções, colisão, interação, portas, HUD e botões touch. **Não testado em Godot/Android ainda.**

Leia primeiro [docs/M1_PLAYABLE.md](docs/M1_PLAYABLE.md), [docs/PALACE_WORLD.md](docs/PALACE_WORLD.md) e [AGENTS.md](AGENTS.md). Abaixo há planejamento anterior, que **não autoriza implementar romance, NPCs, calendário ou história agora**.

---

# Jogo Novo — RPG social de fantasia imperial (pré-produção)

> **Estado:** planejamento de gameplay + bootstrap técnico. Ainda **não existe demo jogável**. Nome provisório; história/lore **não definidos**.

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
Há `project.godot` e uma cena inicial estática de pré-produção. Sistemas, movimento, mapas, diálogos e builds **ainda precisam ser feitos/testados**. Arquivos em `content/` são **exemplos fictícios de schema, não lore**.

## Procedimento
Discussão criativa → classificar em **decidido / proposta / adiado** → atualizar docs → tarefa isolada no Codex → testes → validar com o diretor criativo. Não confundir inspiração de outros jogos com reprodução de material protegido.
