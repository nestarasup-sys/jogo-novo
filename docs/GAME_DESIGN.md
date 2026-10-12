# GDD — visão de gameplay (sem lore)

## Identidade aprovada
RPG social 2D top-down de **romance e fantasia imperial**. Jogamos como uma **princesa imperial** que vive num palácio explorável. Romance, escolhas, interações, relações sociais e capítulos narrativos fazem parte da experiência. O criador escreverá história/lore, personagens e conflitos em outro momento.

## Pilares
1. **Explorar com propósito:** cada ambiente deve conter personagens, interações ou descobertas; evitar corredores vazios.
2. **Rotina com agência:** período do dia molda NPCs e oportunidades, mas sem relógio que pune leitura e exploração.
3. **Relações complexas:** consequências de escolhas + estados/flags, não somente acumular pontos.
4. **Narrativa ramificada:** marcos de capítulo independem de dias; opções alteram cenas e resoluções.
5. **Experiência confortável:** Windows e Android horizontal; controles e legibilidade pensados juntos.

## Loop principal proposto
Acordar no quarto → consultar agenda/avisos (futuro) → escolher onde ir → caminhar e interagir → encontrar NPCs / conversar / decidir → registrar consequências → mudar período ou descansar → desbloquear novos encontros/chapters por condições → salvar.

## Escopo espacial do MVP
Proposta: uma ala privada, uma ala social e os jardins imperiais. O quarto da princesa é âncora e ponto de retorno. `docs/PALACE_WORLD.md` detalha divisão provisória.

## Mecânicas centrais em estudo
- Movimento top-down, colisão, portas/transições e botão contextual de interação.
- Dias livres por períodos; rotinas dos NPCs e eventos contextuais.
- Diálogos ramificados com retratos e escolhas; controles bloqueados durante conversas.
- Variáveis de relação: afinidade, confiança, romance, conflito + estados e flags.
- Condições/marcos/efeitos de eventos com progressão persistente.
- Ambiente e reputação na corte, cartas/convites, guarda-roupa e regras de acesso **são propostas opcionais** a validar.

## Princípios de design
- Não punir jogadores por gastarem tempo lendo.
- Não forçar grind de presentes/conversas para progredir.
- Mostrar consequências de forma narrativa, não exigir que cada escolha revele números.
- Evitar mudanças irreversíveis sem aviso quando a consequência bloquear opção importante.
- Distinguimos eventos obrigatórios recuperáveis e encontros opcionais perdíveis.
- O mapa existe para favorecer interações, não simular arquitetura real do império.

## O que não existe ainda
Nomes, famílias, política, enredo, biografias, conflitos, interesses amorosos, cidade externa e traços definitivos da protagonista. Propostas anteriores não foram adotadas como lore.

Para regras jogáveis e decisões futuras, ver `GAMEPLAY_SYSTEMS.md`; para escopo de implementação, `PROTOTYPE_01.md`.
