# Central do projeto — Jogo Novo

Atualizado em 12/10/2026. Este documento é a referência rápida para decisões confirmadas, propostas e estado de implementação. Em caso de divergência, prevalecem instruções recentes do diretor criativo e o estado real dos arquivos/testes, nunca um plano antigo.

## Visão
RPG social 2D top-down em Godot 4.7.2 / GDScript, com a exploração e rotina como inspiração mecânica em Stardew Valley e narrativa de escolhas e relacionamentos complexos como inspiração em Amor Doce. Obra original, sem copiar assets, personagens ou histórias.

**Protagonista confirmada:** princesa imperial. **Lore, personagens definitivos, biografias e enredo:** ainda não definidos e não devem ser inventados como canon. Estética de fantasia aristocrática; detalhes sujeitos ao diretor criativo.

## Decisões confirmadas
- Plataforma de desenvolvimento e teste **agora: Windows**. Android horizontal continua como meta futura, **somente na fase final**. Não executar tarefas Android sem nova autorização.
- Engine Godot 4.x (protótipo atual usa 4.7.2), GDScript, 2D top-down e viewport-base 1280x720.
- Exploração por dias livres **independente** de capítulos narrativos; capítulos avançam por marcos e condições, não pelo simples passar de dias.
- Romances profundos: afinidade, confiança, romance, conflito, estados explícitos e flags de escolhas; múltiplos desfechos futuros.
- Dados narrativos desacoplados de cenas, com identificadores estáveis, condições declarativas e efeitos idempotentes.
- ChatGPT apoia planejamento/arquitetura/revisão; Codex implementa e testa; diretor criativo define escopo e conteúdo oficial.
- Prototipar pequeno, verificar e expandir. Não criar uma cidade completa, NPCs e sistemas narrativos antes de estabilizar os controles.

## Escopo imediato autorizado (M1)
**Quarto da princesa → mini corredor → jardim**. Quarto perto da entrada do palácio só por conveniência do protótipo (não é lore). O jogador inicia no quarto; saída inferior para corredor; saída inferior do corredor para jardim; retornos funcionais. Andar, colisões, portas/interação e feedback de controles.

Há código e relatórios de testes no repositório; consulte `docs/M1_PLAYABLE.md` e valide a branch/PR mais recente antes de declarar o trabalho pronto. O diretor criativo já relatou que testou e funcionou. O histórico de testes registrados não é substituto de novo teste após mudanças.

## O que NÃO é tarefa autorizada agora
Diálogos completos, capítulos, NPCs com rotinas, calendário, romances, economia, agricultura, combate, mapa grande, história canônica, implementação Android. São planejamento de longo prazo.

## Arquitetura-alvo, NÃO implementada integralmente
- Apresentação: cenas 2D, WorldController, Player, interface e interação.
- Serviços: WorldClock, NpcScheduleService, DialogueController, RelationshipService, EventDirector, ChapterManager.
- Dados: ContentRepository para JSON versionado com validação.
- Persistência: GameState serializável e SaveService em `user://`.
- Comunicação via sinais/eventos, poucas dependências globais e testes da lógica separada de cenas.

Cada camada será introduzida quando necessária, não como estrutura vazia antecipada.

## Navegação rápida
- `README.md` — começar e executar o projeto
- `AGENTS.md` — regras obrigatórias para Codex
- `docs/M1_PLAYABLE.md` — implementação e validações do protótipo atual
- `docs/PALACE_WORLD.md` — topologia de gameplay sugerida
- `docs/DECISIONS.md` — registro de escolhas e prioridades
- `docs/GAMEPLAY_SYSTEMS.md` — mecânicas futuras e hipóteses
- `docs/ARCHITECTURE.md` — arquitetura pretendida
- `docs/CONTENT_SCHEMA.md` — formato preliminar de narrativa
- `docs/PROTOTYPE_01.md` — escopo de prototipagem, sujeito ao M1 atual

## Critérios para o próximo passo
1. Confirmar que alterações da branch do Codex foram integradas à branch principal, ou reconciliar divergências por PR.
2. Rodar importação e smoke tests da versão integrada; testar teclado, colisões, interação e viagens entre as três cenas no Windows.
3. Registrar problemas encontrados e corrigir apenas bugs do protótipo.
4. Só depois pedir ao diretor criativo qual mecânica será a próxima a desenvolver.

Não reescrever a história nem fazer suposições sobre o funcionamento do palácio sem orientação do diretor criativo.
