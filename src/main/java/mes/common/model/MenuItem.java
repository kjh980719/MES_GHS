package mes.common.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MenuItem {
	private int menuSeq;
	private String menuName;
	private String programUrl;
	private int depth;
	private int parentMenuSeq;
	private int displayOrder;
	private boolean selected = false;

}
