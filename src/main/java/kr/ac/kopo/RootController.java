package kr.ac.kopo;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class RootController {

	ArrayList<Item> list;
	
	public RootController() {
		list = new ArrayList<Item>();
	}
	
	@RequestMapping("/")
	String index(Model model) {
		
		model.addAttribute("list",list);
		
		return "index";
	}
	
	@RequestMapping("delete/{title}")
	String delete(@PathVariable String title) {
		for(Item item : list) {
			if(item.getTitle().equals(title)) {
				list.remove(item);
				
				break;
			}
		}
		
		return "redirect:..";
	}
	
	@ResponseBody
	@PostMapping("upload_ajax")
	String uploadAjax(Item item) {
		upload(item);
		
		return item.getFilecode();
	}
	
	@PostMapping("/upload")
	public String upload(Item item) {
		MultipartFile uploadFile = item.getUploadFile();
		if(uploadFile == null || uploadFile.isEmpty()) {
			System.out.println("정상적인 파일을 업로드 해 주세요");
			
		}else {			
			String filename =uploadFile.getOriginalFilename();
			String path = "D:/upload/";
			try {
				String filecode = UUID.randomUUID()+"_"+filename; 
				item.setFilecode(filecode);
				item.setFilename(filename);
				
				uploadFile.transferTo(new File(path + filecode));
				
				list.add(item);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}  
			
			
		}
		
		return "redirect:.";
	}
}
