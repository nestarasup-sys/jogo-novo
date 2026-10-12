# Roadmap — desenvolvimento controlado

## Fundação modular (em revisão, não concluída)
- [x] Protagonista oficial e animação integrada à `main` via PR #2.
- [x] Escrever cenas independentes de quarto, corredor e jardim.
- [x] Escrever catálogo externo, móveis e interações reutilizáveis.
- [x] Escrever câmera uniforme 1.30 com limites e Y-sort.
- [x] Reescrever teste smoke para a nova arquitetura (código, **não executado**).
- [x] Godot Windows: importação e parser sem erros, comprovados no Actions.
- [x] Godot Windows: smoke ampliado passa com assets, movimento, colisões, câmera e portas ([execução](https://github.com/nestarasup-sys/jogo-novo/actions/runs/38216409346)).
- [ ] Godot Windows: inspeção visual/manual no PC do criador, percorrendo todos os ambientes com controles.
- [x] Revisar e integrar a estrutura à `main` (PR #4, após smoke Windows).

## Próximas etapas, uma por vez (não autorizadas automaticamente)
1. Afinar escala, câmera e movimento após teste visual.
2. Integrar arte real de pisos, paredes e móveis por componentes (descartáveis sem efeitos de código).
3. Melhorar interações (respostas visuais, acesso e posicionamento).
4. Rotina de tempo/NPCs; somente com design aprovado.
5. Diálogos, escolhas, romances e saves, em marcos independentes.
6. Android horizontal **apenas na fase final**.

## Regra
Nunca misturar reforma arquitetural com dezenas de sistemas novos. Uma funcionalidade testável por vez. Lore criada pelo diretor criativo.
