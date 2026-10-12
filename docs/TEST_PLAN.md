# Plano de testes — arquitetura modular (pendente execução)

## Automático
- Catálogo JSON presente, schema v1 e todas cenas carregáveis.
- room_id da cena concorda com o catálogo.
- Visual, WorldSpace/Furniture, Interactions e Spawns presentes.
- Todas as portas apontam para ambientes e spawn existentes.
- Quarto inicial e volta jardim→corredor→quarto preservados.
- Prince AnimatedSprite2D com idle, walk, blink e look_back.
- Colisão da princesa existe; objetos têm footprint.
- Câmera 1.30×, limites 1280×720 e HUD CanvasLayer separado.
- Mensagem de inspeção abre e fecha; destino inválido não destrói a cena.

## Manual Windows
- No quarto, testar oito direções, colisão com cama/mesa, alcance do objeto e saída.
- No corredor, passar sem prender na porta, entrar e sair.
- No jardim, fonte e passagem de volta.
- Verificar que objeto/pessoa troca de profundidade conforme Y (YSort).
- Mudar temporariamente zoom para 1.0 e 1.3 no editor: confirmar o mundo e o HUD.
- Inserir móveis/texture dummy (sem Git) e verificar que o componente aceita troca.

## Execução exigida
```powershell
godot --headless --path . --import
godot --headless --path . --script res://tests/smoke.gd
godot --path .
```
**Nenhum teste desta refatoração foi executado em Godot pelo assistente.** O histórico de teste do PR #1/#2 não valida mudanças novas.
