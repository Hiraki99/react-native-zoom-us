package ch.milosz.reactnative.initsdk;

public class AuthParams {

	// TODO Change it to your web domain
	public static String WEB_DOMAIN = null;
	public static String APP_CLIENT_KEY = null;
	public static String APP_CLIENT_SECRET = null;

	/**
	 * We recommend that, you can generate jwttoken on your own server instead of hardcore in the code.
	 * We hardcore it here, just to run the demo.
	 *
	 * You can generate a jwttoken on the https://jwt.io/
	 * with this payload:
	 * {
	 *
	 *     "appKey": "string", // app key
	 *     "iat": long, // access token issue timestamp
	 *     "exp": long, // access token expire time
	 *     "tokenExp": long // token expire time
	 * }
	 */
	String SDK_JWTTOKEN = "SDK_JWTTOKEN";

	public static void init(String domain, String appKey, String appSecret) {
		WEB_DOMAIN = domain;
		APP_CLIENT_KEY = appKey;
		APP_CLIENT_SECRET = appSecret;
	}

	public static boolean isParamsFilled() {
		return WEB_DOMAIN != null && APP_CLIENT_KEY != null && APP_CLIENT_SECRET != null;
	}
}
