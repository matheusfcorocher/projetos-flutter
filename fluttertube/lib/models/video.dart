class Video {
  //Classe representando o video -> API do google
  final String id;
  final String title;
  final String thumb;
  final String channel;

  Video({this.id, this.title, this.thumb, this.channel});


  factory Video.fromJson(Map<String, dynamic> json) {
   if(json.containsKey('id')) {
     //Transforma o seu arquivo ou pag json em um objeto Video
     return Video(
         id : json["id"]["videoId"],
         title: json["snippet"]["title"],
         thumb: json["snippet"]["thumbnails"]["high"]["url"],
         channel: json["snippet"]["channelTitle"]
     );
   }
   else {
     //Retorna no formato video
     return Video(
       id : json['videoId'],
       title: json['title'],
       thumb: json['thumb'],
       channel: json['channel']
     );

   }


  }
  
  Map<String, dynamic> toJson() {
    //Transforma para um mapa do tipo jSon
    return {
      'videoId': id,
      'title': title,
      'thumb' : thumb,
      'channel' : channel
    };
  }

}