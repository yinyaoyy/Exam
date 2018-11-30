/**
 * 
 */
package com.examstack.test;

import org.springframework.security.crypto.password.PasswordEncoder;

import com.examstack.common.util.StandardPasswordEncoderForSha1;

/**
 * @author 王鹏
 * @version 2018-07-04 20:39:12
 */
public class ResetPassword {

	/**
	 * @author 王鹏
	 * @version 2018-07-04 20:39:12
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		resetPassword();//重新生成一个默认密码
	}

	public static void resetPassword() {
		String username = "admin";
		String password = "xmsf2018";
		String sh1Password = password + "{" + username + "}";
		PasswordEncoder passwordEncoder = new StandardPasswordEncoderForSha1();
		String result = passwordEncoder.encode(sh1Password);
		System.out.println(result);
	}
}
