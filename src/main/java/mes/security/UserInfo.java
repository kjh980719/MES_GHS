package mes.security;

import java.awt.MenuItem;
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

	private List<String> provideServices;

	private final boolean accountNonExpired;

	private final boolean accountNonLocked;

	private final boolean credentialsNonExpired;

	private boolean enabled = true;
	private String memberId;
	private String memberPass;
	private String loginOk;
	private boolean memberPassComp;

	// TABLE : Member_User_Master
	private int mbSeq;					// 회원 일련번호
	private String mbType;			    // 회원 유형
	private String mbCd;				// 회원 코드
	private String mbNm;				// 회원 이름
	private String mbEmail;				// 회원 이메일
	private String mbIsPermit;			// 가입 승인여부
	private String mbrGrpCd;			// 회원 그룹코드
	private String mbrGrpNm;			// 회원 그룹이름
	private byte mbIsLive;				// 사용(탈퇴) 여부
	private byte mbIsSleep;				// 휴면계정 여부
	private String isSns;				// sns 회원 구분
	private int authGroupSeq;			// 관리자 메뉴 권한
	private String mbAuthYn;			// 회원 본인인증 여부

	private String gradSeq; // 회원등급 seq
	private String gradNm; // 회원등급명




	//사용자 메뉴 Map
	private Map allowedMenuMap = new HashMap<String, ArrayList<MenuItem>>();

	private String encryptKey;


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
		return mbNm;
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
		this.memberPass = "";
	}

	public String getPassword() { return this.memberPass; }
}
