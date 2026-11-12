# DEVLOG - Pixel Art Corrompido

Organizei este registro depois das implementações, recuperando o histórico do Git e as dúvidas que fui relatando durante o projeto. Separei um resumo e, abaixo, deixei o diário com as mudanças de ideia, os problemas e as partes que precisei retomar.

### Aula 08 - Cenário, personagem e colisões

- de acordo com o sorteio, fiquei com defesa de um objeto por 3 min em um estúdio de pixel art corrompido, montei o estúdio com tiles de 16 pixels e coloquei o artista andando nas quatro direções.
- procurei assets para um jogo lateral, mas encontrava decorações vistas de cima; depois, o personagem atravessava as mesas e cadeiras.
- mudei para top-down, depois de testes gerei os assets por IA e revisei as formas, camadas e máscaras de colisão dos objetos e personagens.
- primeiro commit da base eu fiz em 28/10/2026.

### Aula 09 - Combate, vida e objetivo da Defesa

- implementei combate corpo a corpo, inimigos, vida do artista e do laptop, spawn contínuo, cronômetro, vitória, derrota e reinício.
- precisei rever o alcance e o intervalo dos golpes, a invencibilidade e a posição das informações na tela; também estava usando 1 min de partida antes de corrigir para três.
- ajustei a recarga do ataque para 0,20 segundo e a invencibilidade do artista para 1,2 segundo, mantive cinco vidas no laptop e mudei o HUD para ficar mais bonito.
- os commits de combate e objetivo eu fiz em 29/10/2026; voltei e finalizei em 11/11/2026.

### Aula 10 - Navegação e máquina de estados

- configurei a navegação ao redor dos obstáculos e depois organizei o inimigo com os estados de perseguição, ferido, morto e encerrado, como nos documentos enviados pelo prof.
- o movimento direto não contornava os móveis, o inimigo podia trocar o laptop pelo artista como alvo, deixando de ir pro laptop e seguindo o player.
- usei NavigationRegion2D e NavigationAgent2D pros stickmans contornar os móveis, mantive o laptop como destino e adaptei a estrutura de enum, match e funções de entrada apresentada nas aulas anteriores.
- mantive a compatibilidade com o laptop e acrescentei uma reação de 0,12 segundo ao dano no inimigo.
- fiquei com dúvida se colocava a quantidade de abates de inimigos, pois o documento da aula 10 falava disso, porém como meu jogo é tipo defesa, resolvi não colocar.

### Aula 11 - Arte, dificuldade e teste de desempenho

- substituí a arte do cenário por uma versão mais corrompida e testei a dificuldade e o desempenho da versão jogável.
- o primeiro modelo dos assets não tinha tantos pixels corrompidos, principalmente no piso de madeira; pedi uma nova imagem preservando o atlas de 192 x 176 pixels, daí eu só substituí a imagem usada pelo cenário.
- fiz 3 partidas normais para testar a dificuldade e o desempenho, e percebi que a dificuldade está equilibrada, não é tão fácil de ganhar nem de perder.
- usei spawn de 0,5 segundo e vidas aumentadas por três minutos; o FPS não caiu de 98 (meu máximo estava em 100) e não percebi crescimento anormal de memória ou de nós.
- então mantive a dificuldade como referência e não identifiquei necessidade de otimização na máquina testada;

### Aula 12 - Exportação e publicação

- ainda não fiz essa parte.

## Diário

No começo eu pensei num feiticeiro protegendo um ovo de dragão, com esqueletos atacando e o personagem soltando bolas de fogo, mas ia fugir muito do tema. Depois pensei num programador protegendo um laptop e jogando um mouse nos inimigos. No fim, fiquei com o artista, o laptop e o ataque corpo a corpo, que combinavam mais com o estúdio.

Eu queria fazer com visão lateral, com o boneco pulando, mas os assets de escritório que encontrava eram vistos de cima. Fiquei voltando nessa escolha até mudar pra top-down. Também pedi imagens por IA, mas tive que insistir nos tamanhos e no recorte dos tiles pra conseguir usar na Godot.

Quando montei o cenário, o boneco entrava nas mesas. Eu já tinha tentado colocar colisão e mesmo assim não funcionava, então precisei voltar nessa configuração. Depois que fiz funcionar, ajustei o CollisionShape do boneco ficar somente no pé, e então ficou ok.

Fiz os inimigos de forma simples, testei e tava funcionando certinho, porém combate também não ficou bom de primeira: uma hora achei o alcance grande, depois ficou pequeno, e ainda demorava muito entre os golpes. Eu Fui testando e ajustando até ficar melhor de jogar, eu usei IA para deixar o golpe bacana e com as cores que eu usava no game (azul e rosa) e ficou bom.

Outra coisa que mudei de ideia foi o HUD. Pensei em corações, desisti, depois voltei nessa ideia e acabei ficando com texto mesmo. Só depois arrumei a fonte, as cores e a posição das informações para deixar mais de acordo com o tema e também ficar mais bonitinho.

Quando fui finalizar, voltei a mexer na arte porque quase não parecia que o cenário estava corrompido. Pedi outra imagem, principalmente pro chão de madeira. Troquei a imagem na pasta do projeto pela atual e funcionou, já que eu só pedi para aumentar os pixeis corrompidos. A câmera também precisou de mais de um ajuste: primeiro cortava a parede de cima e, depois que ela apareceu, ainda mostrava as bordas azuis, então modifiquei para ficar enquandrado certinho.

Mais pra frente coloquei obstáculos no caminho dos inimigos e precisei fazer os inimigos darem a volta nos móveis, pois era um requisito do documento do professor. Depois veio a máquina de estados, segui os passos do ClassRoom e com ajuda da IA consegui adaptar pro modelo top-down.

Nos testes de dificuldade e desempenho, não identifiquei necessidade de aumentar a dificuldade, pois o spawn está aleatório e a cada 3s, e os inimigos podem vir de cima ou baixo, as vezes complica defender as duas direções, aumentar o spawn ou diminuir o tempo ia deixar mais difícil do que o necessário. Sobre o desempenho, não notei queda de FPS, usando o depurador do Godot também não identifiquei aumento de nós nem de memória, mesmo depois de testar em cenários de muitos inimigos, final de partida e etc.

Também tive dificuldade com o Git. Tive problema no push porque tinha mexido no README pelo GitHub. Precisei guardar as alterações, sincronizar e enviar de novo. Deixei esse DEVLOG pra depois dos testes justamente pra colocar aqui as mudanças e as partes em que tive que voltar e mexer de novo.