list = getList("window.titles");
     for (i=0; i<list.length; i++){
     winame = list[i];
      selectWindow(winame);
     run("Close");
     }

while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 