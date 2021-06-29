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
            
            
            if(msgText.equals("/start")) {
            	respuesta = mensajeAyuda();
            	enviarMensaje(chatID, respuesta);
            }
             
            
            if(msgText.equals("/guardar") || msgText.startsWith("/guardar")) {
            	if(msgText.length()<10) {
            		respuesta = "Te has olvidado de poner tu tag de BrawlStars.";
            	}
            	else {

                	String tag = msgText.substring(9);
	            	Player player = new Player(tag);
	            	if(player.getStatus()) {
	                	respuesta = "Genial!\nTu tag se ha guardado satisfactoriamente.\n";
	                	respuesta += "Ahora puedes usar el comando /perfil";
	                	dm.agregarCuenta(tag, chatID);
	            	}
	            	else
	            		respuesta = "Ese tag no corresponde con ninguna cuenta de Brawl Stars.";
            	}
            	enviarMensaje(chatID, respuesta);
            }
            
            if(msgText.equals("/perfil")) {
            	Object[] datos = dm.buscarPorIDTelegram(chatID);
            	if(datos==null) {
            		respuesta = "Primero debes registrar tu tag!";
            	}
            	else {
            		String tag = datos[1].toString();
            		Player player = new Player(tag);
            		respuesta = armarPerfil(player);
            		System.out.println(player.toString());
            	}
        		enviarMensaje(chatID, respuesta);
            	
            }
           
        }
	}
	
	private String mensajeAyuda() {
		String msg = "<b>Comandos disponibles:</b>\n\n";
		msg += "Primero debes guardar tu tag de BrawlStars:\n";
		msg += "/guardar #TuTag \n\n";
		msg += "Luego puedes pedir info de tu cuenta:\n";
		msg += "/perfil\n";
		
		return msg;
	}
	
	public String armarPerfil(Player p) {
		String msg = "<b>Nombre:</b><i> " + p.getNombre() + " (#" + p.getTag() + ")</i>\n";
		msg += "<b>Trofeos🏆:</b><i> " + p.getTrofeos() + " (max: " + p.getTrofeosMax() + ")</i>\n";
		msg += "<b>Nivel🔋:</b><i> " + p.getNivel() + "</i>\n";
		msg += "<b>Victorias 3vss3⚔️:</b><i> " + p.getVictorias3vs3() + "</i>\n";
		msg += "<b>Victorias Solo⚔️:</b><i> " + p.getVictoriasSolo() + "</i>\n";
		msg += "<b>Victorias Duo⚔️:</b><i> " + p.getVictoriasDuo() + "</i>\n";
		
		if(p.getClub()!=null) 
			msg += "<b>Club🎖:</b><i> " + p.getClub().getNombre() + " (#" + p.getClub().getTag() + ")</i>\n";
		else
			msg += "<b>Club🎖:</b><i> Ninguno</i>\n";
		return msg;
	}
	
	
	private void enviarMensaje(long chatID, String mensaje) {
        SendMessage msg = new SendMessage();
        msg.setChatId(String.valueOf(chatID));
        msg.enableHtml(true);
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
			File fileToken = new File ("./config/Token_TelegramBot.txt");
			FileReader fr = new FileReader (fileToken);
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
