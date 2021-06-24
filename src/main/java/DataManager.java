import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class DataManager {


	private String ruta = "./db.json";
	private JSONArray jsonArray;
	private SimpleDateFormat formatoFecha;
	
	
	public DataManager() {
		formatoFecha = new SimpleDateFormat("yyyy-MM-dd 'at' HH:mm:ss 'ARG'");
		iniciarJson();
		
		
	}
	
	
	private void iniciarJson() {
		try {
			
			String contenidoJson;
			File file = new File(ruta);
			
			// si el archivo no existe, se inicializa
			if(!file.exists()) { 
		        contenidoJson = "[ ]";
				file.createNewFile();
				FileWriter fw = new FileWriter(file);
		        BufferedWriter bw = new BufferedWriter(fw);
		        bw.write(contenidoJson);
		        bw.close();
		        fw.close();
			} else // si existe, se lee
				contenidoJson = new String((Files.readAllBytes(Paths.get(ruta))));				
		
			jsonArray = new JSONArray(contenidoJson);
		    
		} catch(IOException e) {
			e.printStackTrace();
		}
	}	
	  
	/*
	 * Si no se encuentra, retorna null
	 * Si se encuentra, retorna arreglo con los 3 campos
	 */
    public Object[] buscarPorIDTelegram(long id_telegram){
    	    	
    	Object [] toReturn = null;
    	boolean encontre = false;    	
    	
    	for(int i=0; i<jsonArray.length() && !encontre; i++) {
    		
    		JSONObject item = jsonArray.getJSONObject(i);
    		if(item.getLong("id_telegram")==id_telegram) {
    			
    			try {
    				
	    			encontre = true;
	    			toReturn = new Object[4];
	    			
					toReturn[0] = formatoFecha.parse(item.getString("time"));
	    			toReturn[1] = item.getString("tag_brawl");
	    			toReturn[2] = item.getInt("id_telegram");	   
					toReturn[3] = i; // guardo el indice
	    			
				} catch (JSONException e) {
					e.printStackTrace();
				} catch (ParseException e) {
					e.printStackTrace();
				}    			
    		}    		
    	}    	
    	
    	return toReturn;
    	
    }  
	/*
	 * Si no se encuentra, retorna null
	 * Si se encuentra, retorna arreglo con los 3 campos
	 */
    public Object[] buscarPorTagBrawl(String tag_brawl){
    	    	
    	Object [] toReturn = null;
    	boolean encontre = false;    	
    	
    	for(int i=0; i<jsonArray.length() && !encontre; i++) {
    		
    		JSONObject item = jsonArray.getJSONObject(i);
    		if(item.getString("tag_brawl").equals(tag_brawl)) {
    			
    			try {
    				
	    			encontre = true;
	    			toReturn = new Object[4];
	    			
					toReturn[0] = formatoFecha.parse(item.getString("time"));
	    			toReturn[1] = item.getString("tag_brawl");
	    			toReturn[2] = item.getInt("id_telegram");		   
					toReturn[3] = i; // guardo el indice   
					
				} catch (JSONException e) {
					e.printStackTrace();
				} catch (ParseException e) {
					e.printStackTrace();
				}    			
    		}    		
    	}    		
    	return toReturn;
    }
    
    
    
    public void borrarCuenta(long idTelegram) {

    	boolean encontre = false;    	
    	
    	for(int i=0; i<jsonArray.length() && !encontre; i++) {
    		
    		JSONObject item = jsonArray.getJSONObject(i);
    		if(item.getLong("id_telegram")==idTelegram) {
    			
				encontre = true;
				jsonArray.remove(i);	
    		}
    	}
    }
	
  
    
    public void agregarCuenta(String tagBrawl,long idTelegram){

		Date date = new Date(System.currentTimeMillis());

		JSONObject item;
		boolean encontre = false;  
		// Si lo encuentro, actualizo TAG del brawl y HORA
    	for(int i=0; i<jsonArray.length() && !encontre; i++) {
    		
    		item = jsonArray.getJSONObject(i);
    		if(item.getInt("id_telegram")==idTelegram) {
    		
    			encontre = true;
    			item.put("tag_brawl",tagBrawl);
    			item.put("time", formatoFecha.format(date));
    			
    		}
    	}
    	
    	// Si no lo encuentro, agrego una nueva entrada
    	if(!encontre) {
    		item = new JSONObject();
			item.put("time", formatoFecha.format(date));
	        item.put("tag_brawl", tagBrawl);	
	        item.put("id_telegram", idTelegram);
			jsonArray.put(item);
    	}
    	
        // actualizo el archivo
		try {
			FileWriter file = new FileWriter(ruta);
	        file.write(jsonArray.toString(3));
	        file.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
}
