> **ATUALIZAÇÃO DE ESCOPO (12/10/2026):** a etapa atualmente autorizada é SOMENTE testar e corrigir os controles de **quarto → mini corredor → jardim**. A porta inferior do corredor conduz ao jardim. A cena inicial é o quarto da princesa. Código inicial em `scenes/maps/`, `scripts/game.gd`, `player.gd`, `prototype_map.gd`, `prototype_hud.gd`, `mobile_controls.gd`, e teste `tests/smoke.gd`. **Ainda não foi executado na Godot**. O Codex deve importar, validar, testar e consertar, sem adicionar NPC, história, capítulos, tempo ou romances. Consultar [M1_PLAYABLE.md](M1_PLAYABLE.md). Todas as ideias abaixo são backlog de longo prazo, não tarefas desta rodada.

---

# Gameplay e mecânicas — laboratório de design

**Status:** conjunto de decisões firmes + propostas a testar. Não é uma autorização para implementar todos os sistemas. Consultar `DECISIONS.md`.

## 1. Loop central (decidido em alto nível)
Explorar ambiente do palácio → encontrar personagem/objeto → interagir → ler diálogo/selecionar ação → mudar relacionamento/flags/estado da sociedade → seguir explorando ou avançar período → desbloquear eventos e progressão narrativa.

### Sensação desejada
Ritmo aconchegante de exploração com tensão social quando um evento importante aparece. A história deve ser profunda sem transformar tudo em menus de visual novel.

## 2. Exploração (proposta detalhada para protótipo)
- Movimento 4 ou 8 direções (testar 8 primeiro) com câmera top-down.
- Colisões simples, entrada em salas/portas, indicadores de interação ao se aproximar.
- Interação com um único alvo por vez, por proximidade e prioridade visual previsível.
- Jogador não pode atravessar portas inacessíveis; UI informa razão (ex.: acesso restrito), sem surpresa silenciosa.
- Transições preservam destino e direção de chegada; HUD permanece consistente.
- Ao iniciar diálogo, bloquear deslocamento e ações do mundo; interface continua operável.

**Controles propostos:** Windows WASD/setas + E/interação + Esc/menu. Android joystick virtual à esquerda, ação contextual à direita, botões de menu acessíveis sem cobrir texto; possibilitar opção de toque-direto em fases posteriores.

## 3. Tempo e agenda (dias + capítulos decididos; granularidade proposta)
- V0.1 usa `morning`, `afternoon`, `evening` e contador de dias.
- Período avança por ação explícita ou escolha do jogador, **não por segundos em tempo real**.
- Descansar à noite avança ao próximo dia e volta à manhã; não permitir retroceder tempo.
- NPCs recebem posição por local/período, com fallback definido caso um evento os afaste.
- Eventos principais recuperáveis para não bloquear capítulo por perder uma janela opcional.
- Incluir indicador de período e próximo passo, sem exibir cronômetro pressionando jogador.

## 4. Conversas e escolhas (essencial)
- Retrato, nome do falante, texto em português, opções de resposta.
- Escolhas podem ajustar relações, registrar flags e desbloquear cena.
- Escolhas importantes devem ter IDs estáveis e consequências **aplicadas uma vez**.
- Variações textuais por condições e eventos anteriores, sem copiar falas em scripts de mapa.
- Pergunta de design: mostrar ou esconder mudanças numéricas? Preferência provisória: feedback sutil (expressão/reação) + diário opcional.
- Skip/velocidade de texto e histórico de falas desejáveis, mas não obrigatórios V0.1.

## 5. Relações e romance (profundidade decidida; números propostos)
- Dimensões provisórias: `affinity`, `trust`, `romance`, `conflict` de 0 a 100.
- Estados possíveis: `strangers`, `acquaintances`, `friends`, `romantic_interest`, `dating`, `estranged`.
- Estado **não é derivado apenas por pontos**; fatos (promessas, segredos, escolhas) importam.
- Uma única resposta nunca deveria resolver automaticamente todo um conflito sério.
- Eventos românticos específicos e exclusividade entre rotas exigem design posterior, com clareza para jogador.

## 6. Reputação na corte (IDEIA — não aprovada)
Uma variável de percepção pública/rumores **separada** do que cada NPC sente:
- Ação pública pode melhorar prestígio e prejudicar vínculo específico (ou vice-versa).
- Rumores exigiriam fonte e contexto; não gerar punição sem pistas.
- V0.1 pode conter **um flag de notoriedade de teste**, não sistema social amplo.

## 7. Correspondências e convites (IDEIA — não aprovada)
A escrivaninha do quarto poderia oferecer:
- Caixa de entrada, convites com opções aceitar/recusar/adiar, cartas com respostas.
- Agenda para eventos com período/local e lembrete no HUD.
- Não criar dezenas de telas no protótipo. Primeiro demonstrar um único objeto interativo genérico.

## 8. Vestuário/etiqueta (IDEIA — não aprovada)
- Guarda-roupa com looks funcionais/estéticos; sem bônus obrigatórios ou grind.
- Trajes podem alterar diálogos em um baile/cerimônia, com requisitos claros.
- Não bloquear eventos da história por faltar item irrepetível.

## 9. Acesso a locais (IDEIA)
Alguns cômodos podem abrir por capítulo/permissão/horário, mas bloqueios precisam ser legíveis. Não usar dezenas de mapas para compensar falta de conteúdo. Áreas futuras: corte, capital, torre/academia, floresta — **não aprovadas**.

## 10. Desafio de design: evitar grind
A dificuldade deve vir de conflitos de prioridades e consequências, não de repetir cumprimentos 20 vezes. Limitar conversas genéricas por período; recompensar escolhas e descobertas; criar eventos alternativos para encontros importantes.

## 11. O que V0.1 precisa provar
1. Explorar quarto, ala social e jardins (divisão provisória).
2. Conversar com ao menos um NPC em local/período certo.
3. Escolher entre duas respostas, ver mudança no estado persistente.
4. Tomar decisão A/B e experimentar duas resoluções genéricas de teste.
5. Avançar vários dias sem que capítulo mude sozinho.
6. Salvar/carregar progressos no Windows; validar Android horizontal em etapa posterior.

## 12. Sistemas pós-demo a explorar
Correio/agenda, guarda-roupa, diário, reputação com facções, bailes/cerimônias, passeios pela capital, missões sociais, decoração de aposentos, acessibilidade avançada, histórico de escolhas, calendário mais fino.

**Nada nesta seção cria fatos sobre enredo ou personagens oficiais.**
