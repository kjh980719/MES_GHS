package mes.security;

import mes.common.model.MenuItem;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.security.core.CredentialsContainer;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.SpringSecurityCoreVersion;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.*;

@Getter
@Setter
@ToString
public class UserInfo implements CredentialsContainer, UserDetails {

	private static final long serialVersionUID = SpringSecurityCoreVersion.SERIAL_VERSION_UID;

	private Collection<GrantedAuthority> authorities = new TreeSet<GrantedAuthority>();

	private final boolean accountNonExpired;

	private final boolean accountNonLocked;

	private final boolean credentialsNonExpired;

	private boolean enabled = true;
	private int managerSeq;
	private String managerId;
	private String password;
	private int loginFailCount;
	private int authGroupSeq;
	private String managerName;
	private String managerEmail;
	private String useYn;
	private String groupUseYn;
	private String managerTel;
	private String managerPosition;
	private String groupName;
	
	//�궗�슜�옄 硫붾돱 Map
	private Map allowedMenuMap = new HashMap<String, ArrayList<MenuItem>>();

	public UserInfo() {
		this.accountNonExpired = true;
		this.accountNonLocked = true;
		this.credentialsNonExpired = true;
	}
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return this.authorities;
	}

	@Override
	public String getUsername() {
		return null;
	}

	@Override
	public boolean isAccountNonExpired() {
		return this.accountNonExpired;
	}

	@Override
	public boolean isAccountNonLocked() {
		return this.accountNonLocked;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return this.credentialsNonExpired;
	}

	@Override
	public void eraseCredentials() {
		this.password = "";
	}

}
