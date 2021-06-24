import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import org.telegram.telegrambots.bots.TelegramLongPollingBot;
import org.telegram.telegrambots.meta.api.methods.send.SendMessage;
import org.telegram.telegrambots.meta.api.objects.Update;
import org.telegram.telegrambots.meta.exceptions.TelegramApiException;

import GeneratedObjects.Player;



public class BotCreator extends TelegramLongPollingBot {


    private DataManager dm;
	
    
	public BotCreator() {
		super();
		dm = new DataManager();
	}
	
	
	
	@Override
	public void onUpdateReceived(Update update) {
		
        if (update.hasMessage() && update.getMessage().hasText()) {
            String msgText = update.getMessage().getText();
            long chatID = update.getMessage().getChatId();

            String respuesta = "";
            
            if(msgText.startsWith("/guardar ")) {
            	String tag = msgText.substring(9);
            	tag = tag.replaceAll("#", "");
            	Player player = new Player(tag);
            	if(player.getStatus())
                	respuesta = "Genial!\nTu tag se ha guardado satisfactoriamente.";
            	else
            		respuesta = "Ese tag no corresponde con ninguna cuenta de Brawl Stars.";
            	dm.agregarCuenta(tag, chatID);
            	enviarMensaje(chatID, respuesta);
            }
            
            if(msgText.equals("/perfil") || msgText.equals("/p")) {
            	Object[] datos = dm.buscarPorIDTelegram(chatID);
            	if(datos==null) {
            		respuesta = "Primero debes registrar tu tag!";
            	}
            	else {
            		String tag = datos[1].toString();
            		Player player = new Player(tag);
            		respuesta = player.toString();
            		System.out.println(player.toString());
            	}
        		enviarMensaje(chatID, respuesta);
            	
            }

           
        }
	}
	
	private void enviarMensaje(long chatID, String mensaje) {
        SendMessage msg = new SendMessage();
        msg.setChatId(String.valueOf(chatID));
        msg.setText(mensaje); 
        try {
            execute(msg); 
        } catch (TelegramApiException e) {
            e.printStackTrace();
        }
		
	}
	
	
	@Override
	public String getBotUsername() {
		return "@bs_stats_bot";
	}

	
	@Override
	public String getBotToken() {		
		String token = "";
		try {
			File archivoToken = new File ("tokenBotTelegram.txt");
			FileReader fr = new FileReader (archivoToken);
			BufferedReader br = new BufferedReader(fr);
			token = br.readLine();
			br.close();
			fr.close();			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return token;
	}
	
}
