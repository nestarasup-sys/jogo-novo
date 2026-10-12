# Plano de testes

## Automáticos (a criar)
- Importação headless do projeto sem erro.
- Dados JSON válidos; IDs/referências duplicadas ou inexistentes rejeitados.
- Condições `all`/`any` e operadores whitelist avaliados corretamente.
- Evento repetido não duplica ajuste de stat ou progresso.
- Capítulo não avança só pela passagem de dias.
- Mudanças de relacionamento respeitam limites [0,100].
- Save/load round-trip com posições, períodos, relações, flags e capítulo.
- Saves corrompidos retornam erro controlado sem perder backup.

## Manuais
- Windows: Novo Jogo, movimentação, três mapas, conversa, conflito, save/load.
- Android físico: APK abre em landscape, diferentes proporções, toque e safe areas.
- Diálogo: texto legível, menu/cancel, avanço seguro sem clicar duas opções.
- Desfechos: pelo menos dois percursos documentados geram finais diferentes.

## Execução futura
Após o Codex criar o runner, documentar os comandos exatos. Não afirmar que testes foram executados antes da existência do runner e do ambiente Godot/SDK.

## Relato obrigatório
Ambiente, versão Godot, comandos, dispositivo, resultado, falhas reproduzíveis e limitações.
