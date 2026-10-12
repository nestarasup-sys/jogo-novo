> **ATUALIZAÇÃO DE ESCOPO (12/10/2026):** a etapa atualmente autorizada é SOMENTE testar e corrigir os controles de **quarto → mini corredor → jardim**. A porta inferior do corredor conduz ao jardim. A cena inicial é o quarto da princesa. Código inicial em `scenes/maps/`, `scripts/game.gd`, `player.gd`, `prototype_map.gd`, `prototype_hud.gd`, `mobile_controls.gd`, e teste `tests/smoke.gd`. **Ainda não foi executado na Godot**. O Codex deve importar, validar, testar e consertar, sem adicionar NPC, história, capítulos, tempo ou romances. Consultar [M1_PLAYABLE.md](M1_PLAYABLE.md). Todas as ideias abaixo são backlog de longo prazo, não tarefas desta rodada.

---

# Palácio — mapa lógico de gameplay (proposta)

**Status:** arquitetura espacial sugerida, **não aprovada como planta definitiva**. A origem da protagonista como princesa imperial e seu quarto no palácio estão definidos.

## Três macroáreas antigas (adiadas; não implementar)
| Zona / map_id | Propósito | Microambientes potenciais |
|---|---|---|
| `private_wing` | Base segura da protagonista, descanso e objetos pessoais | quarto, corredor, gabinete, closet |
| `social_wing` | Interações públicas/semipúblicas, circulação de NPCs | corredor central, salão de chá, biblioteca, salão de recepção |
| `imperial_gardens` | Área externa para encontros e exploração | fonte, pavilhão, roseiral, portão da guarda |

**V0.1 só exige 3 cenas principais exploráveis;** microambientes podem começar como cenários/objetos no mesmo mapa. Não criar 10 mapas ou assets completos agora.

## Grafo de navegação sugerido
```text
[Ala privada / quarto] <-> [Ala social / corredor] <-> [Jardins imperiais]
```
Nas versões futuras, as conexões devem funcionar nos dois sentidos, ter spawns definidos e não teletransportar o jogador para parede.

## Experiência de cada área
- Ala privada: início/fim do dia e objeto pessoal interativo de teste (futura escrivaninha/correspondência).
- Ala social: concentra NPCs, rumores/convites futuros e interações formais.
- Jardins: exploração mais aberta, um NPC por período e gatilhos espaciais de eventos.

## Regras de ambientação
- O palácio deve parecer vivo: NPCs mudam de posição com o período.
- Interação contextual: visitar, falar, ler objeto, descansar, sair.
- Rótulos claros quando porta estiver fechada; não criar bloqueio narrativo insolúvel.
- A atmosfera manhwa pode ser obtida por arquitetura ornamental e retratos, independentemente do estilo final ser pixel-art ou ilustrado (decisão pendente).

## Áreas para depois (não comprometidas)
Corte imperial como ala extra, capital do reino, academia/torre, floresta/ruínas. Não implementar antes de validar o núcleo do palácio.

## Câmera, assets e produção
Mapas pequenos inicialmente; placeholders geométricos; tiles/arte finais só após escolha visual. A navegação deve ser testável sem detalhes artísticos. Nomes `private_wing`, `social_wing`, `imperial_gardens` são IDs técnicos temporários, mas devem permanecer estáveis quando usados em saves reais.
