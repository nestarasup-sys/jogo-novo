# Plano de validação — Protótipo de palácio

**Estado:** plano, ainda não testes executados.

## Automáticos (a criar)
- Godot importa/abre projeto headless sem falhas.
- Interações não selecionam NPC atrás de parede nem múltiplos alvos ao mesmo tempo.
- Transições de `private_wing` ↔ `social_wing` ↔ `imperial_gardens` usam spawn válido.
- Agenda troca NPCs corretamente nos períodos.
- Tempo não avança durante diálogo e capítulo não avança só por dormir.
- JSON: IDs/referências/operadores inválidos causam erro detectável.
- Condições, efeitos e estatísticas são determinísticos e limitados.
- Escolha repetida não duplica efeito, inclusive após reabrir save.
- Saves corrompidos falham sem apagar cópias válidas.
- Testar variantes A/B do evento genérico e restaurar a variante correta.

## Manuais Windows
Novo jogo, movimento, colisão, portas, conversa, escolha, avanço de tempo, save/load, interface de diálogos e menu.

## Manuais Android em aparelho real
APK landscape, joystick touch e botão, legibilidade, layouts >16:9, safe areas, transições, save/load, performance sem engasgos excessivos.

## Trilha de teste
1. Importação/execução headless quando houver Godot.
2. Domínio usando runner de testes quando implementado.
3. Jogo manual no PC.
4. Build Android e teste físico.
5. Relatório de ambiente, versões, comandos, falhas e gravação/prints se útil.

Não afirmar execução de testes ainda indisponíveis.
