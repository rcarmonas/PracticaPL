package Interfaz;

import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.JPanel;

/*
 * Nomenclatura imagenes:
 * 	0 - Vacio
 * 	1 - Jugador
 * 	2 - Jugador-Viento
 * 	3 - Jugador-Olor
 * 	4 - Jugador-Viento-Olor
 * 	5 - Viento
 * 	6 - Olor
 * 	7 - Viento-Olor
 * 	8 - Desconocido
 */

public class ImagePanel extends JPanel{

    private BufferedImage image;
    String imagen[] = {"vacio", "jugador", "jugador-viento", "jugador-olor", "jugador-viento-olor", "viento", "olor", "viento-olor", "desconocido"};

    public ImagePanel(String ruta) {
       try {                
          image = ImageIO.read(new File(ruta));
       } catch (IOException ex) {
            ex.printStackTrace();
       }
    }

    public ImagePanel(int index) {
       try {                
          image = ImageIO.read(new File("img/" + imagen[index] + ".png"));
       } catch (IOException ex) {
            ex.printStackTrace();
       }
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.drawImage(image, 0, 0, null); // see javadoc for more info on the parameters            
    }

}