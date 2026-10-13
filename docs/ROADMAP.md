# Roadmap — experiência editável no Godot

## Etapa imediata: corrigir arquitetura editor-first
- [x] Criar `@tool` para desenhar piso/parede, móveis e marcadores no editor.
- [x] Migrar colisões dos móveis e paredes para nós persistentes nas cenas.
- [x] Criar cena de protagonista, com animações e câmera editáveis.
- [x] Colocar quarto, protagonista e HUD na cena principal.
- [x] Documentar procedimento para qualquer área nova.
- [x] Validar importação da Godot 4.7.2 Windows, sem erros ([Actions](https://github.com/nestarasup-sys/jogo-novo/actions/runs/38335444897)).
- [x] Validar smoke com nós do editor e protagonista ([Actions](https://github.com/nestarasup-sys/jogo-novo/actions/runs/38335444897)).
- [ ] Verificar visualmente em uma janela/editor real o posicionamento, as camadas, as portas e a princesa.
- [x] PR #5 mesclado à main após os testes automáticos; inspeção manual ainda pendente.

## Depois, por aprovação do criador
1. Adicionar texturas substituíveis de piso e parede pelo Inspector.
2. Adicionar móveis reais como sprites individuais, preservando footprint e interações.
3. Melhorar feedback de interação e qualidade da exploração.
4. Só depois discutir novos sistemas e lore.

## Regras
Windows primeiro, Android ao final. Uma funcionalidade validada de cada vez. Não reconstruir mapas/móveis/colisões em código de inicialização.
