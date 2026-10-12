# Jogo Novo — RPG social narrativo

> Projeto em pré-produção. Nome temporário: **Jogo Novo**. Ainda não é uma demo jogável.

Jogo 2D top-down para **Windows e Android (horizontal)**, combinando exploração e rotinas sociais inspiradas em *Stardew Valley* com narrativas, escolhas e romances ramificados inspirados em *Amor Doce*. Referências são de **mecânicas/gênero**, não autorização para copiar arte, personagens ou conteúdo de terceiros.

## Visão
- Explore casa, praça, escola e futuramente uma cidade maior.
- Viva dias livres com períodos de manhã, tarde e noite.
- Avance capítulos conforme **condições narrativas**, nunca apenas pela passagem de dias.
- Construa relações com afinidade, confiança, romance, conflito, estados de relacionamento e escolhas persistentes.
- Experimente rotas e desfechos diferentes.
- Jogue com teclado no Windows e controles de toque no Android horizontal.

## Decisões
- Engine: **Godot 4.x estável**, versão exata a fixar antes de implementar e testar; GDScript.
- 2D top-down; resolução de design 1280×720; renderizador Compatibility como ponto de partida.
- História e definições de NPC/eventos em JSON UTF-8; dados validados, IDs estáveis.
- Save local versionado em `user://`; comunicação preferencialmente por sinais.
- Programação feita com ChatGPT/Codex, com o criador liderando direção criativa, avaliação e testes.
- **V0.1 = vertical slice**, não um Stardew completo.

## Estado atual
Este repositório contém documentos, estrutura básica do projeto e **exemplos de dados**. Não há garantias de jogabilidade, build Android/Windows ou sistema narrativo implementado ainda.

## Comece aqui
1. [Visão e decisões](docs/GAME_DESIGN.md)
2. [Arquitetura](docs/ARCHITECTURE.md)
3. [Escopo e critérios da V0.1](docs/PROTOTYPE_01.md)
4. [Formato dos dados](docs/CONTENT_SCHEMA.md)
5. [Roadmap](docs/ROADMAP.md)
6. [Instruções do Codex](AGENTS.md)

## Para abrir
Instale a versão estável da Godot 4.x escolhida pelo projeto e abra `project.godot`. A cena atual é somente uma tela provisória de identificação. Comandos headless e exports serão configurados e validados durante a implementação.

## Processo
Criar uma branch por tarefa, PR revisável e teste antes do merge. Não anunciar funcionalidades como prontas sem validação. Dúvidas de design vão para `docs/OPEN_QUESTIONS.md`.
