> **DECISÃO ATUAL — Windows primeiro (12/10/2026).** O criador testou a movimentação e informou que o protótipo funciona. O Codex publicou validações da Godot 4.7.2 no [PR #1](https://github.com/nestarasup-sys/jogo-novo/pull/1), ainda pendente de merge. **Desenvolver, executar, testar e distribuir inicialmente apenas para Windows**. Android continua como plataforma futura, mas **não executar tarefas Android, SDK, APK, touchscreen ou adaptação de UI mobile** nesta fase, salvo ordem expressa do criador. Não expandir mecânicas sem novo escopo aprovado. O resultado do PR está na branch `codex/m1-playable-movement`; documentos da main podem estar desatualizados até merge.

---

> **ATUALIZAÇÃO DE ESCOPO (12/10/2026):** a etapa atualmente autorizada é SOMENTE testar e corrigir os controles de **quarto → mini corredor → jardim**. A porta inferior do corredor conduz ao jardim. A cena inicial é o quarto da princesa. Código inicial em `scenes/maps/`, `scripts/game.gd`, `player.gd`, `prototype_map.gd`, `prototype_hud.gd`, `mobile_controls.gd`, e teste `tests/smoke.gd`. **Ainda não foi executado na Godot**. O Codex deve importar, validar, testar e consertar, sem adicionar NPC, história, capítulos, tempo ou romances. Consultar [M1_PLAYABLE.md](docs/M1_PLAYABLE.md). Todas as ideias abaixo são backlog de longo prazo, não tarefas desta rodada.

---

# AGENTS.md — Contrato de trabalho com Codex

Antes de escrever código, ler `README.md`, `docs/DECISIONS.md`, `docs/GAMEPLAY_SYSTEMS.md`, `docs/PALACE_WORLD.md`, `docs/PROTOTYPE_01.md`, `docs/ARCHITECTURE.md` e `docs/CONTENT_SCHEMA.md`.

## Autoridade de design
O usuário é o diretor criativo. **Não inventar lore canônica**, famílias, sucessão, segredos, biografias, romances oficiais, nomes definitivos nem roteiro principal sem autorização explícita. Ideias anteriores do assistente (como decreto falso, Lia, príncipe herdeiro, história da sucessão) **não são canonizadas**. Use conteúdo neutro marcado como `example` em testes/protótipos.

## Decisões firmes
- RPG social de fantasia imperial, protagonista princesa imperial (idade e biografia não definidas).
- Godot 4.x, GDScript; multiplataforma Windows + Android horizontal.
- Top-down explorável, rotina de NPCs, diálogos/romances com consequências.
- Dias livres independentes de capítulos por condições; sem travar progressão por perder evento opcional.
- Três zonas do palácio são **proposta provisória** para vertical slice, não mapa final.

## Implementação
1. Desenvolva de modo incremental; uma milestone por vez (ver `docs/ROADMAP.md`).
2. Separe UI, mundo, domínio e dados; priorize scripts tipados e serviços testáveis.
3. No início, somente `GameState` e `GameEvents` como Autoloads; mais globais exigem justificativa técnica.
4. Identificadores em snake_case estáveis; JSON declarativo com validação e whitelist. **Nunca executar código a partir de JSON**.
5. Eventos/efeitos precisam ser determinísticos e idempotentes, inclusive após carregar saves.
6. Registre escolhas, flags, capítulo, horário/período, mapa, posição e relações em save versionado.
7. Projete teclado e toque em conjunto; diálogo pausa movimento e tempo, mas não bloqueia UI.
8. Não adicione agricultura, combate, economia complexa, geografia extra, correspondência/reputação/guarda-roupa completos sem aprovação de escopo.
9. Referências a obras são inspirações de gênero. Não copiar personagens, cenários ou arte. Verificar licença de assets e plugins.
10. Não adicionar tokens, credenciais, chaves de assinatura Android ou outputs de build ao Git.

## Entregas
Para cada tarefa: mudanças, testes realmente executados, ambiente, limitações, riscos e próximos passos. Se não houver Godot/Android SDK, declarar o que **não** foi testado. Nunca reportar build validada em dispositivo físico sem testes reais.

## Processo
- Documentar novas ideias em `OPEN_QUESTIONS.md` ou `GAMEPLAY_SYSTEMS.md` como propostas.
- Modificar `DECISIONS.md` para "decidido" **somente após aprovação explícita do criador**.
- Usar branches/PRs por funcionalidade quando houver código significativo; evitar mudanças não relacionadas na mesma entrega.
- Código/IDs em inglês; interface e documentação em português brasileiro.

## Próxima implementação (quando autorizada)
M1: projeto Godot validado, GameRoot mínimo, cena e movimento top-down/colisões, input teclado e scaffolding touch, teste headless. **Não começar novas etapas só porque há documentação delas.**
