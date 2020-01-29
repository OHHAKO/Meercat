package dao;

import java.util.Random;

public class RandomSession {
	
	private static int LENGTH = 8; // 문자열길이
	public static String getRandomSession() {

		char[] charaters = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
				's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };

		StringBuffer sb = new StringBuffer();
		Random random = new Random();

		for (int i = 0; i < LENGTH; i++) {
			sb.append(charaters[random.nextInt(charaters.length)]);
		}
		return sb.toString();
	}
}
