package mes.app.util;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Locale;

/*
 * Copyright 2001-2006 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the ";License&quot;);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS"; BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 *
 *
 * @author : jihhong
 * @version $Revision$  $Date$
 * @see
 */
public class StringUtil {
    /**
     * 鍮� 臾몄옄�뿴 <code>""</code>.
     */
	// �궗�슜�옄 �젙蹂� 以� passwd瑜� �븫�샇�솕 �븯湲� �쐞�븳 parsing媛�.
	public final static String Ref = "`1234567890-=~!@#$%^&*()_+qwertyuiop[]QWERTYUIOP{}|asdfghjkl;ASDFGHJKL:zxcvbnm,./ZXCVBNM<>?";
    public static final String EMPTY = "";
    
    /**
     * <p>Padding�쓣 �븷 �닔 �엳�뒗 理쒕� �닔移�</p>
     */
    // private static final int PAD_LIMIT = 8192;
    
    /**
     * <p>An array of <code>String</code>s used for padding.</p>
     * <p>Used for efficient space padding. The length of each String expands as needed.</p>
     */
    /*
	private static final String[] PADDING = new String[Character.MAX_VALUE];

	static {
		// space padding is most common, start with 64 chars
		PADDING[32] = "                                                                ";
	}	
     */	
	
	/**
	 * <pre>
	 * DES MD5 �븫�샇�솕 �빐�떆肄붾뱶 諛섑솚
	 * </pre>
	 *
	 * @param   source   �븫�샇�솕�븷 臾몄옄�뿴
	 * @return  �븫�샇�솕�맂 臾몄옄�뿴
	 */
    public static String encrypt(String source) {
    	MD5 md5 = new MD5();
    	return md5.getHash(source);
    }
    /**
     * 臾몄옄�뿴�씠 吏��젙�븳 湲몄씠瑜� 珥덇낵�뻽�쓣�븣 吏��젙�븳湲몄씠�뿉�떎媛� �빐�떦 臾몄옄�뿴�쓣 遺숈뿬二쇰뒗 硫붿꽌�뱶.
     * @param source �썝蹂� 臾몄옄�뿴 諛곗뿴
     * @param output �뜑�븷臾몄옄�뿴
     * @param slength 吏��젙湲몄씠
     * @return 吏��젙湲몄씠濡� �옒�씪�꽌 �뜑�븷遺꾩옄�뿴 �빀移� 臾몄옄�뿴
     */
    public static String cutString(String source, String output, int slength) {
        String returnVal = null;
        if (source != null) {
            if (source.length() > slength) {
                returnVal = source.substring(0, slength) + output;
            } else
                returnVal = source;
        }
        return returnVal;
    }

    /**
     * 臾몄옄�뿴�씠 吏��젙�븳 湲몄씠瑜� 珥덇낵�뻽�쓣�븣 �빐�떦 臾몄옄�뿴�쓣 �궘�젣�븯�뒗 硫붿꽌�뱶
     * @param source �썝蹂� 臾몄옄�뿴 諛곗뿴
     * @param slength 吏��젙湲몄씠
     * @return 吏��젙湲몄씠濡� �옒�씪�꽌 �뜑�븷遺꾩옄�뿴 �빀移� 臾몄옄�뿴
     */
    public static String cutString(String source, int slength) {
        String result = null;
        if (source != null) {
            if (source.length() > slength) {
                result = source.substring(0, slength);
            } else
                result = source;
        }
        return result;
    }    
  
    /**
     * <p>
     * String�씠 鍮꾩뿀嫄곕굹("") �샊�� null �씤吏� 寃�利앺븳�떎.
     * </p>
     * 
     * <pre>
     *  StringUtil.isEmpty(null)      = true
     *  StringUtil.isEmpty("")        = true
     *  StringUtil.isEmpty(" ")       = false
     *  StringUtil.isEmpty("bob")     = false
     *  StringUtil.isEmpty("  bob  ") = false
     * </pre>
     * 
     * @param str - 泥댄겕 ���긽 �뒪�듃留곸삤釉뚯젥�듃�씠硫� null�쓣 �뿀�슜�븿
     * @return <code>true</code> - �엯�젰諛쏆� String �씠 鍮� 臾몄옄�뿴 �삉�뒗 null�씤 寃쎌슦 
     */
    public static boolean isEmpty(String str) {
        return str == null || str.length() == 0;
    }

    
    /**
     * <p>湲곗� 臾몄옄�뿴�뿉 �룷�븿�맂 紐⑤뱺 ���긽 臾몄옄(char)瑜� �젣嫄고븳�떎.</p>
     *
     * <pre>
     * StringUtil.remove(null, *)       = null
     * StringUtil.remove("", *)         = ""
     * StringUtil.remove("queued", 'u') = "qeed"
     * StringUtil.remove("queued", 'z') = "queued"
     * </pre>
     *
     * @param str  �엯�젰諛쏅뒗 湲곗� 臾몄옄�뿴
     * @param remove  �엯�젰諛쏅뒗 臾몄옄�뿴�뿉�꽌 �젣嫄고븷 ���긽 臾몄옄�뿴
     * @return �젣嫄곕��긽 臾몄옄�뿴�씠 �젣嫄곕맂 �엯�젰臾몄옄�뿴. �엯�젰臾몄옄�뿴�씠 null�씤 寃쎌슦 異쒕젰臾몄옄�뿴�� null
     */
    public static String remove(String str, char remove) {
        if (isEmpty(str) || str.indexOf(remove) == -1) {
            return str;
        }
        char[] chars = str.toCharArray();
        int pos = 0;
        for (int i = 0; i < chars.length; i++) {
            if (chars[i] != remove) {
                chars[pos++] = chars[i];
            }
        }
        return new String(chars, 0, pos);
    }
    
    /**
     * <p>臾몄옄�뿴 �궡遺��쓽 肄ㅻ쭏 character(,)瑜� 紐⑤몢 �젣嫄고븳�떎.</p>
     *
     * <pre>
     * StringUtil.removeCommaChar(null)       = null
     * StringUtil.removeCommaChar("")         = ""
     * StringUtil.removeCommaChar("asdfg,qweqe") = "asdfgqweqe"
     * </pre>
     *
     * @param str �엯�젰諛쏅뒗 湲곗� 臾몄옄�뿴
     * @return " , "媛� �젣嫄곕맂 �엯�젰臾몄옄�뿴
     *  �엯�젰臾몄옄�뿴�씠 null�씤 寃쎌슦 異쒕젰臾몄옄�뿴�� null
     */
    public static String removeCommaChar(String str) {
        return remove(str, ',');
    }
    
    /**
     * <p>臾몄옄�뿴 �궡遺��쓽 留덉씠�꼫�뒪 character(-)瑜� 紐⑤몢 �젣嫄고븳�떎.</p>
     *
     * <pre>
     * StringUtil.removeMinusChar(null)       = null
     * StringUtil.removeMinusChar("")         = ""
     * StringUtil.removeMinusChar("a-sdfg-qweqe") = "asdfgqweqe"
     * </pre>
     *
     * @param str  �엯�젰諛쏅뒗 湲곗� 臾몄옄�뿴
     * @return " - "媛� �젣嫄곕맂 �엯�젰臾몄옄�뿴
     *  �엯�젰臾몄옄�뿴�씠 null�씤 寃쎌슦 異쒕젰臾몄옄�뿴�� null
     */
    public static String removeMinusChar(String str) {
        return remove(str, '-');
    }
        
    
    /**
     * �썝蹂� 臾몄옄�뿴�쓽 �룷�븿�맂 �듅�젙 臾몄옄�뿴�쓣 �깉濡쒖슫 臾몄옄�뿴濡� 蹂��솚�븯�뒗 硫붿꽌�뱶
     * @param source �썝蹂� 臾몄옄�뿴
     * @param subject �썝蹂� 臾몄옄�뿴�뿉 �룷�븿�맂 �듅�젙 臾몄옄�뿴
     * @param object 蹂��솚�븷 臾몄옄�뿴
     * @return sb.toString() �깉濡쒖슫 臾몄옄�뿴濡� 蹂��솚�맂 臾몄옄�뿴
     */
    public static String replace(String source, String subject, String object) {
        StringBuffer rtnStr = new StringBuffer();
        String preStr = "";
        String nextStr = source;
        String srcStr  = source;
        
        while (srcStr.indexOf(subject) >= 0) {
            preStr = srcStr.substring(0, srcStr.indexOf(subject));
            nextStr = srcStr.substring(srcStr.indexOf(subject) + subject.length(), srcStr.length());
            srcStr = nextStr;
            rtnStr.append(preStr).append(object);
        }
        rtnStr.append(nextStr);
        return rtnStr.toString();
    }

    /**
     * �썝蹂� 臾몄옄�뿴�쓽 �룷�븿�맂 �듅�젙 臾몄옄�뿴 泥ル쾲吏� �븳媛쒕쭔 �깉濡쒖슫 臾몄옄�뿴濡� 蹂��솚�븯�뒗 硫붿꽌�뱶
     * @param source �썝蹂� 臾몄옄�뿴
     * @param subject �썝蹂� 臾몄옄�뿴�뿉 �룷�븿�맂 �듅�젙 臾몄옄�뿴
     * @param object 蹂��솚�븷 臾몄옄�뿴
     * @return sb.toString() �깉濡쒖슫 臾몄옄�뿴濡� 蹂��솚�맂 臾몄옄�뿴 / source �듅�젙臾몄옄�뿴�씠 �뾾�뒗 寃쎌슦 �썝蹂� 臾몄옄�뿴
     */
    public static String replaceOnce(String source, String subject, String object) {
        StringBuffer rtnStr = new StringBuffer();
        String preStr = "";
        String nextStr = source;
        if (source.indexOf(subject) >= 0) {
            preStr = source.substring(0, source.indexOf(subject));
            nextStr = source.substring(source.indexOf(subject) + subject.length(), source.length());
            rtnStr.append(preStr).append(object).append(nextStr);
            return rtnStr.toString();
        } else {
            return source;
        }
    }

    /**
     * <code>subject</code>�뿉 �룷�븿�맂 媛곴컖�쓽 臾몄옄瑜� object濡� 蹂��솚�븳�떎.
     * 
     * @param source �썝蹂� 臾몄옄�뿴
     * @param subject �썝蹂� 臾몄옄�뿴�뿉 �룷�븿�맂 �듅�젙 臾몄옄�뿴
     * @param object 蹂��솚�븷 臾몄옄�뿴
     * @return sb.toString() �깉濡쒖슫 臾몄옄�뿴濡� 蹂��솚�맂 臾몄옄�뿴
     */
    public static String replaceChar(String source, String subject, String object) {
        StringBuffer rtnStr = new StringBuffer();
        String preStr = "";
        String nextStr = source;
        String srcStr  = source;
        
        char chA;

        for (int i = 0; i < subject.length(); i++) {
            chA = subject.charAt(i);

            if (srcStr.indexOf(chA) >= 0) {
                preStr = srcStr.substring(0, srcStr.indexOf(chA));
                nextStr = srcStr.substring(srcStr.indexOf(chA) + 1, srcStr.length());
                srcStr = rtnStr.append(preStr).append(object).append(nextStr).toString();
            }
        }
        
        return srcStr;
    }  
    
    /**
     * <p><code>str</code> 以� <code>searchStr</code>�쓽 �떆�옉(index) �쐞移섎�� 諛섑솚.</p>
     *
     * <p>�엯�젰媛� 以� <code>null</code>�씠 �엳�쓣 寃쎌슦 <code>-1</code>�쓣 諛섑솚.</p>
     *
     * <pre>
     * StringUtil.indexOf(null, *)          = -1
     * StringUtil.indexOf(*, null)          = -1
     * StringUtil.indexOf("", "")           = 0
     * StringUtil.indexOf("aabaabaa", "a")  = 0
     * StringUtil.indexOf("aabaabaa", "b")  = 2
     * StringUtil.indexOf("aabaabaa", "ab") = 1
     * StringUtil.indexOf("aabaabaa", "")   = 0
     * </pre>
     *
     * @param str  寃��깋 臾몄옄�뿴
     * @param searchStr  寃��깋 ���긽臾몄옄�뿴
     * @return 寃��깋 臾몄옄�뿴 以� 寃��깋 ���긽臾몄옄�뿴�씠 �엳�뒗 �떆�옉 �쐞移� 寃��깋���긽 臾몄옄�뿴�씠 �뾾嫄곕굹 null�씤 寃쎌슦 -1
     */
    public static int indexOf(String str, String searchStr) {
        if (str == null || searchStr == null) {
            return -1;
        }
        return str.indexOf(searchStr);
    }    
    
    
    /**
     * <p>�삤�씪�겢�쓽 decode �븿�닔�� �룞�씪�븳 湲곕뒫�쓣 媛�吏� 硫붿꽌�뱶�씠�떎.
     * <code>sourStr</code>怨� <code>compareStr</code>�쓽 媛믪씠 媛숈쑝硫�
     * <code>returStr</code>�쓣 諛섑솚�븯硫�, �떎瑜대㈃  <code>defaultStr</code>�쓣 諛섑솚�븳�떎.
     * </p>
     * 
     * <pre>
     * StringUtil.decode(null, null, "foo", "bar")= "foo"
     * StringUtil.decode("", null, "foo", "bar") = "bar"
     * StringUtil.decode(null, "", "foo", "bar") = "bar"
     * StringUtil.decode("�븯�씠", "�븯�씠", null, "bar") = null
     * StringUtil.decode("�븯�씠", "�븯�씠  ", "foo", null) = null
     * StringUtil.decode("�븯�씠", "�븯�씠", "foo", "bar") = "foo"
     * StringUtil.decode("�븯�씠", "�븯�씠  ", "foo", "bar") = "bar"
     * </pre>
     * 
     * @param sourceStr 鍮꾧탳�븷 臾몄옄�뿴
     * @param compareStr 鍮꾧탳 ���긽 臾몄옄�뿴
     * @param returnStr sourceStr�� compareStr�쓽 媛믪씠 媛숈쓣 �븣 諛섑솚�븷 臾몄옄�뿴
     * @param defaultStr sourceStr�� compareStr�쓽 媛믪씠 �떎瑜� �븣 諛섑솚�븷 臾몄옄�뿴
     * @return sourceStr怨� compareStr�쓽 媛믪씠 �룞�씪(equal)�븷 �븣 returnStr�쓣 諛섑솚�븯硫�,
     *         <br/>�떎瑜대㈃ defaultStr�쓣 諛섑솚�븳�떎.
     */
    public static String decode(String sourceStr, String compareStr, String returnStr, String defaultStr) {
        if (sourceStr == null && compareStr == null) {
            return returnStr;
        }
        
        if (sourceStr == null && compareStr != null) {
            return defaultStr;
        }

        if (sourceStr.trim().equals(compareStr)) {
            return returnStr;
        }

        return defaultStr;
    }

    /**
     * <p>�삤�씪�겢�쓽 decode �븿�닔�� �룞�씪�븳 湲곕뒫�쓣 媛�吏� 硫붿꽌�뱶�씠�떎.
     * <code>sourStr</code>怨� <code>compareStr</code>�쓽 媛믪씠 媛숈쑝硫�
     * <code>returStr</code>�쓣 諛섑솚�븯硫�, �떎瑜대㈃  <code>sourceStr</code>�쓣 諛섑솚�븳�떎.
     * </p>
     * 
     * <pre>
     * StringUtil.decode(null, null, "foo") = "foo"
     * StringUtil.decode("", null, "foo") = ""
     * StringUtil.decode(null, "", "foo") = null
     * StringUtil.decode("�븯�씠", "�븯�씠", "foo") = "foo"
     * StringUtil.decode("�븯�씠", "�븯�씠 ", "foo") = "�븯�씠"
     * StringUtil.decode("�븯�씠", "諛붿씠", "foo") = "�븯�씠"
     * </pre>
     * 
     * @param sourceStr 鍮꾧탳�븷 臾몄옄�뿴
     * @param compareStr 鍮꾧탳 ���긽 臾몄옄�뿴
     * @param returnStr sourceStr�� compareStr�쓽 媛믪씠 媛숈쓣 �븣 諛섑솚�븷 臾몄옄�뿴
     * @return sourceStr怨� compareStr�쓽 媛믪씠 �룞�씪(equal)�븷 �븣 returnStr�쓣 諛섑솚�븯硫�,
     *         <br/>�떎瑜대㈃ sourceStr�쓣 諛섑솚�븳�떎.
     */
    public static String decode(String sourceStr, String compareStr, String returnStr) {
        return decode(sourceStr, compareStr, returnStr, sourceStr);
    }    
    
    /**
     * 媛앹껜媛� null�씤吏� �솗�씤�븯怨� null�씤 寃쎌슦 "" 濡� 諛붽씀�뒗 硫붿꽌�뱶
     * @param object �썝蹂� 媛앹껜
     * @return resultVal 臾몄옄�뿴
     */
    public static String isNullToString(Object object) {
        String string = "";
        
        if (object != null) {
            string = object.toString().trim();
        }
        
        return string;
    }
    
    /**
     *<pre>
     * �씤�옄濡� 諛쏆� String�씠 null�씪 寃쎌슦 &quot;&quot;濡� 由ы꽩�븳�떎.
     * &#064;param src null媛믪씪 媛��뒫�꽦�씠 �엳�뒗 String 媛�.
     * &#064;return 留뚯빟 String�씠 null 媛믪씪 寃쎌슦 &quot;&quot;濡� 諛붽씔 String 媛�.
     *</pre>
     */
    public static String nullConvert(Object src) {
	//if (src != null && src.getClass().getName().equals("java.math.BigDecimal")) {
	if (src != null && src instanceof BigDecimal) {
	    return ((BigDecimal)src).toString();
	}

	if (src == null || src.equals("null")) {
	    return "";
	} else {
	    return ((String)src).trim();
	}
    }
    
    /**
     *<pre>
     * �씤�옄濡� 諛쏆� String�씠 null�씪 寃쎌슦 &quot;&quot;濡� 由ы꽩�븳�떎.
     * &#064;param src null媛믪씪 媛��뒫�꽦�씠 �엳�뒗 String 媛�.
     * &#064;return 留뚯빟 String�씠 null 媛믪씪 寃쎌슦 &quot;&quot;濡� 諛붽씔 String 媛�.
     *</pre>
     */
    public static String nullConvert(String src) {

	if (src == null || src.equals("null") || "".equals(src) || " ".equals(src)) {
	    return "";
	} else {
	    return src.trim();
	}
    }	
	
    /**
     *<pre>
     * �씤�옄濡� 諛쏆� String�씠 null�씪 寃쎌슦 &quot;0&quot;濡� 由ы꽩�븳�떎.
     * &#064;param src null媛믪씪 媛��뒫�꽦�씠 �엳�뒗 String 媛�.
     * &#064;return 留뚯빟 String�씠 null 媛믪씪 寃쎌슦 &quot;0&quot;濡� 諛붽씔 String 媛�.
     *</pre>
     */
    public static int zeroConvert(Object src) {

	if (src == null || src.equals("null")) {
	    return 0;
	} else {
	    return Integer.parseInt(((String)src).trim());
	}
    }

    /**
     *<pre>
     * �씤�옄濡� 諛쏆� String�씠 null�씪 寃쎌슦 &quot;&quot;濡� 由ы꽩�븳�떎.
     * &#064;param src null媛믪씪 媛��뒫�꽦�씠 �엳�뒗 String 媛�.
     * &#064;return 留뚯빟 String�씠 null 媛믪씪 寃쎌슦 &quot;&quot;濡� 諛붽씔 String 媛�.
     *</pre>
     */
    public static int zeroConvert(String src) {

	if (src == null || src.equals("null") || "".equals(src) || " ".equals(src)) {
	    return 0;
	} else {
	    return Integer.parseInt(src.trim());
	}
    }
	
    /**
     *<pre>
     * �씤�옄濡� 諛쏆� String�씠 null�씪 寃쎌슦 &quot;&quot;濡� 由ы꽩�븳�떎.
     * &#064;param src null媛믪씪 媛��뒫�꽦�씠 �엳�뒗 String 媛�.
     * &#064;return 留뚯빟 String�씠 null 媛믪씪 寃쎌슦 &quot;&quot;濡� 諛붽씔 String 媛�.
     *</pre>
     */
    public static String stringZeroConvert(String src) {
    	
    	if (src == null || src.equals("null") || "".equals(src) || " ".equals(src)) {
    		return "0";
    	} else {
    		return src.trim();
    	}
    }
    
    /**
     * <p>臾몄옄�뿴�뿉�꽌 {@link Character#isWhitespace(char)}�뿉 �젙�쓽�맂 
     * 紐⑤뱺 怨듬갚臾몄옄瑜� �젣嫄고븳�떎.</p>
     *
     * <pre>
     * StringUtil.removeWhitespace(null)         = null
     * StringUtil.removeWhitespace("")           = ""
     * StringUtil.removeWhitespace("abc")        = "abc"
     * StringUtil.removeWhitespace("   ab  c  ") = "abc"
     * </pre>
     *
     * @param str  怨듬갚臾몄옄媛� �젣嫄곕룄�뼱�빞 �븷 臾몄옄�뿴
     * @return the 怨듬갚臾몄옄媛� �젣嫄곕맂 臾몄옄�뿴, null�씠 �엯�젰�릺硫� <code>null</code>�씠 由ы꽩
     */
    public static String removeWhitespace(String str) {
        if (isEmpty(str)) {
            return str;
        }
        int sz = str.length();
        char[] chs = new char[sz];
        int count = 0;
        for (int i = 0; i < sz; i++) {
            if (!Character.isWhitespace(str.charAt(i))) {
                chs[count++] = str.charAt(i);
            }
        }
        if (count == sz) {
            return str;
        }
        
        return new String(chs, 0, count);
    }
    	
    /**
     * Html 肄붾뱶媛� �뱾�뼱媛� 臾몄꽌瑜� �몴�떆�븷�븣 �깭洹몄뿉 �넀�긽�뾾�씠 蹂댁씠湲� �쐞�븳 硫붿꽌�뱶
     * 
     * @param strString
     * @return HTML �깭洹몃�� 移섑솚�븳 臾몄옄�뿴
     */
    public static String checkHtmlView(String strString) {
	String strNew = "";

	try {
	    StringBuffer strTxt = new StringBuffer("");

	    char chrBuff;
	    int len = strString.length();

	    for (int i = 0; i < len; i++) {
		chrBuff = (char)strString.charAt(i);

		switch (chrBuff) {
		case '<':
		    strTxt.append("&lt;");
		    break;
		case '>':
		    strTxt.append("&gt;");
		    break;
		case '"':
		    strTxt.append("&quot;");
		    break;
		case 10:
		    strTxt.append("<br>");
		    break;
		case ' ':
		    strTxt.append("&nbsp;");
		    break;
		//case '&' :
		    //strTxt.append("&amp;");
		    //break;
		default:
		    strTxt.append(chrBuff);
		}
	    }

	    strNew = strTxt.toString();

	} catch (Exception ex) {
	    return null;
	}

	return strNew;
    }
	
	
    /**
     * 臾몄옄�뿴�쓣 吏��젙�븳 遺꾨━�옄�뿉 �쓽�빐 諛곗뿴濡� 由ы꽩�븯�뒗 硫붿꽌�뱶.
     * @param source �썝蹂� 臾몄옄�뿴
     * @param separator 遺꾨━�옄
     * @return result 遺꾨━�옄濡� �굹�돇�뼱吏� 臾몄옄�뿴 諛곗뿴
     */
    public static String[] split(String source, String separator) throws NullPointerException {
        String[] returnVal = null;
        int cnt = 1;

        int index = source.indexOf(separator);
        int index0 = 0;
        while (index >= 0) {
            cnt++;
            index = source.indexOf(separator, index + 1);
        }
        returnVal = new String[cnt];
        cnt = 0;
        index = source.indexOf(separator);
        while (index >= 0) {
            returnVal[cnt] = source.substring(index0, index);
            index0 = index + 1;
            index = source.indexOf(separator, index + 1);
            cnt++;
        }
        returnVal[cnt] = source.substring(index0);
        
        return returnVal;
    }
    
    /**
     * <p>{@link String#toLowerCase()}瑜� �씠�슜�븯�뿬 �냼臾몄옄濡� 蹂��솚�븳�떎.</p>
     *
     * <pre>
     * StringUtil.lowerCase(null)  = null
     * StringUtil.lowerCase("")    = ""
     * StringUtil.lowerCase("aBc") = "abc"
     * </pre>
     *
     * @param str �냼臾몄옄濡� 蹂��솚�릺�뼱�빞 �븷 臾몄옄�뿴
     * @return �냼臾몄옄濡� 蹂��솚�맂 臾몄옄�뿴, null�씠 �엯�젰�릺硫� <code>null</code> 由ы꽩
     */
    public static String lowerCase(String str) {
        if (str == null) {
            return null;
        }
        
        return str.toLowerCase();
    }
    
    /**
     * <p>{@link String#toUpperCase()}瑜� �씠�슜�븯�뿬 ��臾몄옄濡� 蹂��솚�븳�떎.</p>
     *
     * <pre>
     * StringUtil.upperCase(null)  = null
     * StringUtil.upperCase("")    = ""
     * StringUtil.upperCase("aBc") = "ABC"
     * </pre>
     *
     * @param str ��臾몄옄濡� 蹂��솚�릺�뼱�빞 �븷 臾몄옄�뿴
     * @return ��臾몄옄濡� 蹂��솚�맂 臾몄옄�뿴, null�씠 �엯�젰�릺硫� <code>null</code> 由ы꽩
     */
    public static String upperCase(String str) {
        if (str == null) {
            return null;
        }
        
        return str.toUpperCase();
    }
    
    /**
     * <p>�엯�젰�맂 String�쓽 �븵履쎌뿉�꽌 �몢踰덉㎏ �씤�옄濡� �쟾�떖�맂 臾몄옄(stripChars)瑜� 紐⑤몢 �젣嫄고븳�떎.</p>
     *
     * <pre>
     * StringUtil.stripStart(null, *)          = null
     * StringUtil.stripStart("", *)            = ""
     * StringUtil.stripStart("abc", "")        = "abc"
     * StringUtil.stripStart("abc", null)      = "abc"
     * StringUtil.stripStart("  abc", null)    = "abc"
     * StringUtil.stripStart("abc  ", null)    = "abc  "
     * StringUtil.stripStart(" abc ", null)    = "abc "
     * StringUtil.stripStart("yxabc  ", "xyz") = "abc  "
     * </pre>
     *
     * @param str 吏��젙�맂 臾몄옄媛� �젣嫄곕릺�뼱�빞 �븷 臾몄옄�뿴
     * @param stripChars �젣嫄곕��긽 臾몄옄�뿴
     * @return 吏��젙�맂 臾몄옄媛� �젣嫄곕맂 臾몄옄�뿴, null�씠 �엯�젰�릺硫� <code>null</code> 由ы꽩
     */
    public static String stripStart(String str, String stripChars) {
        int strLen;
        if (str == null || (strLen = str.length()) == 0) {
            return str;
        }
        int start = 0;
        if (stripChars == null) {
            while ((start != strLen) && Character.isWhitespace(str.charAt(start))) {
                start++;
            }
        } else if (stripChars.length() == 0) {
            return str;
        } else {
            while ((start != strLen) && (stripChars.indexOf(str.charAt(start)) != -1)) {
                start++;
            }
        }
        
        return str.substring(start);
    }


    /**
     * <p>�엯�젰�맂 String�쓽 �뮘履쎌뿉�꽌 �몢踰덉㎏ �씤�옄濡� �쟾�떖�맂 臾몄옄(stripChars)瑜� 紐⑤몢 �젣嫄고븳�떎.</p>
     *
     * <pre>
     * StringUtil.stripEnd(null, *)          = null
     * StringUtil.stripEnd("", *)            = ""
     * StringUtil.stripEnd("abc", "")        = "abc"
     * StringUtil.stripEnd("abc", null)      = "abc"
     * StringUtil.stripEnd("  abc", null)    = "  abc"
     * StringUtil.stripEnd("abc  ", null)    = "abc"
     * StringUtil.stripEnd(" abc ", null)    = " abc"
     * StringUtil.stripEnd("  abcyx", "xyz") = "  abc"
     * </pre>
     *
     * @param str 吏��젙�맂 臾몄옄媛� �젣嫄곕릺�뼱�빞 �븷 臾몄옄�뿴
     * @param stripChars �젣嫄곕��긽 臾몄옄�뿴
     * @return 吏��젙�맂 臾몄옄媛� �젣嫄곕맂 臾몄옄�뿴, null�씠 �엯�젰�릺硫� <code>null</code> 由ы꽩
     */
    public static String stripEnd(String str, String stripChars) {
        int end;
        if (str == null || (end = str.length()) == 0) {
            return str;
        }

        if (stripChars == null) {
            while ((end != 0) && Character.isWhitespace(str.charAt(end - 1))) {
                end--;
            }
        } else if (stripChars.length() == 0) {
            return str;
        } else {
            while ((end != 0) && (stripChars.indexOf(str.charAt(end - 1)) != -1)) {
                end--;
            }
        }
        
        return str.substring(0, end);
    }

    /**
     * <p>�엯�젰�맂 String�쓽 �븵, �뮘�뿉�꽌 �몢踰덉㎏ �씤�옄濡� �쟾�떖�맂 臾몄옄(stripChars)瑜� 紐⑤몢 �젣嫄고븳�떎.</p>
     * 
     * <pre>
     * StringUtil.strip(null, *)          = null
     * StringUtil.strip("", *)            = ""
     * StringUtil.strip("abc", null)      = "abc"
     * StringUtil.strip("  abc", null)    = "abc"
     * StringUtil.strip("abc  ", null)    = "abc"
     * StringUtil.strip(" abc ", null)    = "abc"
     * StringUtil.strip("  abcyx", "xyz") = "  abc"
     * </pre>
     *
     * @param str 吏��젙�맂 臾몄옄媛� �젣嫄곕릺�뼱�빞 �븷 臾몄옄�뿴
     * @param stripChars �젣嫄곕��긽 臾몄옄�뿴
     * @return 吏��젙�맂 臾몄옄媛� �젣嫄곕맂 臾몄옄�뿴, null�씠 �엯�젰�릺硫� <code>null</code> 由ы꽩
     */
    public static String strip(String str, String stripChars) {
	if (isEmpty(str)) {
	    return str;
	}

	String srcStr = str;
	srcStr = stripStart(srcStr, stripChars);
	
	return stripEnd(srcStr, stripChars);
    }

    /**
     * 臾몄옄�뿴�쓣 吏��젙�븳 遺꾨━�옄�뿉 �쓽�빐 吏��젙�맂 湲몄씠�쓽 諛곗뿴濡� 由ы꽩�븯�뒗 硫붿꽌�뱶.
     * @param source �썝蹂� 臾몄옄�뿴
     * @param separator 遺꾨━�옄
     * @param arraylength 諛곗뿴 湲몄씠
     * @return 遺꾨━�옄濡� �굹�돇�뼱吏� 臾몄옄�뿴 諛곗뿴
     */
    public static String[] split(String source, String separator, int arraylength) throws NullPointerException {
        String[] returnVal = new String[arraylength];
        int cnt = 0;
        int index0 = 0;
        int index = source.indexOf(separator);
        while (index >= 0 && cnt < (arraylength - 1)) {
            returnVal[cnt] = source.substring(index0, index);
            index0 = index + 1;
            index = source.indexOf(separator, index + 1);
            cnt++;
        }
        returnVal[cnt] = source.substring(index0);
        if (cnt < (arraylength - 1)) {
            for (int i = cnt + 1; i < arraylength; i++) {
                returnVal[i] = "";
            }
        }
        
        return returnVal;
    }

    /**
     * 臾몄옄�뿴 A�뿉�꽌 Z�궗�씠�쓽 �옖�뜡 臾몄옄�뿴�쓣 援ы븯�뒗 湲곕뒫�쓣 �젣怨� �떆�옉臾몄옄�뿴怨� 醫낅즺臾몄옄�뿴 �궗�씠�쓽 �옖�뜡 臾몄옄�뿴�쓣 援ы븯�뒗 湲곕뒫
     * 
     * @param startChr
     *            - 泥� 臾몄옄
     * @param endChr
     *            - 留덉�留됰Ц�옄
     * @return �옖�뜡臾몄옄
     * @exception MyException
     * @see
     */
    public static String getRandomStr(char startChr, char endChr) {

	int randomInt;
	String randomStr = null;

	// �떆�옉臾몄옄 諛� 醫낅즺臾몄옄瑜� �븘�뒪�궎�닽�옄濡� 蹂��솚�븳�떎.
	int startInt = Integer.valueOf(startChr);
	int endInt = Integer.valueOf(endChr);

	// �떆�옉臾몄옄�뿴�씠 醫낅즺臾몄옄�뿴蹂닿� �겢寃쎌슦
	if (startInt > endInt) {
	    throw new IllegalArgumentException("Start String: " + startChr + " End String: " + endChr);
	}

	try {
	    // �옖�뜡 媛앹껜 �깮�꽦
	    SecureRandom rnd = new SecureRandom();

	    do {
		// �떆�옉臾몄옄 諛� 醫낅즺臾몄옄 以묒뿉�꽌 �옖�뜡 �닽�옄瑜� 諛쒖깮�떆�궓�떎.
		randomInt = rnd.nextInt(endInt + 1);
	    } while (randomInt < startInt); // �엯�젰諛쏆� 臾몄옄 'A'(65)蹂대떎 �옉�쑝硫� �떎�떆 �옖�뜡 �닽�옄 諛쒖깮.

	    // �옖�뜡 �닽�옄瑜� 臾몄옄濡� 蹂��솚 �썑 �뒪�듃留곸쑝濡� �떎�떆 蹂��솚
	    randomStr = (char)randomInt + "";
	} catch (Exception e) {
	    e.printStackTrace();
	}

	// �옖�뜡臾몄옄�뿴瑜� 由ы꽩
	return randomStr;
    }

    /**
     * 臾몄옄�뿴�쓣 �떎�뼇�븳 臾몄옄�뀑(EUC-KR[KSC5601],UTF-8..)�쓣 �궗�슜�븯�뿬 �씤肄붾뵫�븯�뒗 湲곕뒫 �뿭�쑝濡� �뵒肄붾뵫�븯�뿬 �썝�옒�쓽 臾몄옄�뿴�쓣
     * 蹂듭썝�븯�뒗 湲곕뒫�쓣 �젣怨듯븿 String temp = new String(臾몄옄�뿴.getBytes("諛붽씀湲곗쟾 �씤肄붾뵫"),"諛붽� �씤肄붾뵫");
     * String temp = new String(臾몄옄�뿴.getBytes("8859_1"),"KSC5601"); => UTF-8 �뿉�꽌
     * EUC-KR
     * 
     * @param srcString
     *            - 臾몄옄�뿴
     * @param srcCharsetNm
     *            - �썝�옒 CharsetNm
     * @param charsetNm
     *            - CharsetNm
     * @return �씤(�뵒)肄붾뵫 臾몄옄�뿴
     * @exception MyException
     * @see
     */
    public static String getEncdDcd(String srcString, String srcCharsetNm, String cnvrCharsetNm) {

	String rtnStr = null;

	if (srcString == null)
	    return null;

	try {
	    rtnStr = new String(srcString.getBytes(srcCharsetNm), cnvrCharsetNm);
	} catch (UnsupportedEncodingException e) {
	    rtnStr = null;
	}

	return rtnStr;
    }

/**
     * �듅�닔臾몄옄瑜� �쎒 釉뚮씪�슦���뿉�꽌 �젙�긽�쟻�쑝濡� 蹂댁씠湲� �쐞�빐 �듅�닔臾몄옄瑜� 泥섎━('<' -> & lT)�븯�뒗 湲곕뒫�씠�떎
     * @param 	srcString 		- '<' 
     * @return 	蹂��솚臾몄옄�뿴('<' -> "&lt"
     * @exception MyException 
     * @see  
     */
    public static String getSpclStrCnvr(String srcString) {

	String rtnStr = null;

	try {
	    StringBuffer strTxt = new StringBuffer("");

	    char chrBuff;
	    int len = srcString.length();

	    for (int i = 0; i < len; i++) {
		chrBuff = (char)srcString.charAt(i);

		switch (chrBuff) {
		case '<':
		    strTxt.append("&lt;");
		    break;
		case '>':
		    strTxt.append("&gt;");
		    break;
		case '&':
		    strTxt.append("&amp;");
		    break;
		default:
		    strTxt.append(chrBuff);
		}
	    }

	    rtnStr = strTxt.toString();

	} catch (Exception e) {
	    e.printStackTrace();
	}

	return rtnStr;
    }

    /**
     * �쓳�슜�뼱�뵆由ъ��씠�뀡�뿉�꽌 怨좎쑀媛믪쓣 �궗�슜�븯湲� �쐞�빐 �떆�뒪�뀥�뿉�꽌17�옄由ъ쓽TIMESTAMP媛믪쓣 援ы븯�뒗 湲곕뒫
     * 
     * @param
     * @return Timestamp 媛�
     * @exception MyException
     * @see
     */
    public static String getTimeStamp() {

	String rtnStr = null;

	// 臾몄옄�뿴濡� 蹂��솚�븯湲� �쐞�븳 �뙣�꽩 �꽕�젙(�뀈�룄-�썡-�씪 �떆:遺�:珥�:珥�(�옄�젙�씠�썑 珥�))
	String pattern = "yyyyMMddhhmmssSSS";

	try {
	    SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
	    Timestamp ts = new Timestamp(System.currentTimeMillis());

	    rtnStr = sdfCurrent.format(ts.getTime());
	} catch (Exception e) {
	    e.printStackTrace();
	}

	return rtnStr;
    }

	/**
	 * parse媛믪뿉�꽌 �쐞移섏뿉 �빐�떦�븯�뒗 臾몄옄瑜� 由ы꽩
	 */
	public static char getNtoc(int idx) {

		return (Ref.charAt(idx));
	}
	
	/**
	 * parse�뿉�꽌 �쐞移섍컪�쓣 由ы꽩
	 */
	public static int getCton(char chr) {

		return (Ref.indexOf(chr));
	}
    
	/**
	 * Decode�븯怨좎옄 �븯�뒗 pwssword瑜� �엯�젰諛쏆븘 decode�븯�뿬 由ы꽩�븳�떎.
	 */
	public static String getPwdDecode(String pwd, int CipherVal) {

		StringBuffer buf = new StringBuffer("");

		int i = 0;
		char chr = ' ';
		int Conv = 0;
		int Cipher = 0;
		char CipherChr = ' ';
		for (i = 0; i < pwd.length(); i++) {

			chr = pwd.charAt(i);

			Conv = getCton(chr);
			Cipher = Conv ^ CipherVal;
			CipherChr = getNtoc(Cipher);

			buf.append(CipherChr);
		}
		return buf.toString();
	}
	
	public static String printDate(String date, String separater)
	{
		String ret = date;
		if( date.length() == 8 ) {
			ret = date.substring(0,4) + separater + date.substring(4,6) + separater + date.substring(6,8);
		} else if( date.length() == 10 ) {
			ret = date.substring(0,4) + separater + date.substring(5,7) + separater + date.substring(8,10);
		}
		return ret;
	}
	
	public static String setComma(String value) {
		if(value.equals("")) {
			return "";
		}
		return value.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",");
	}

	/**
	 * VO 以� String field �쓽 value 媛� null �씠硫� "" 濡� 蹂�寃쏀븯�뿬 由ы꽩
	 * @param instance
	 * @return
	 */
	public static Object nullToEmptyString(Object instance) {
		Class clazz = instance.getClass();
		Field[] fields = clazz.getDeclaredFields();
		for (Field field : fields) {
			try {
				field.setAccessible(true);
				if(field.getType() == String.class & field.get(instance) == null) {
					field.set(instance, "");
				}
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
		//�긽�쐞 �겢�옒�뒪媛� �엳�뒗寃쎌슦 �긽�쐞�겢�옒�뒪 源뚯�留�..(�뿬�윭踰� �긽�냽諛쏆�寃쎌슦�뒗 �떎�떆 �닔�젙 �븘�슂)
		if (clazz.getSuperclass() != Object.class) {
			Field[] pFields = clazz.getSuperclass().getDeclaredFields();
			for (Field field : pFields) {
				try {
					field.setAccessible(true);
					if(field.getType() == String.class & field.get(instance) == null) {
						field.set(instance, "");
					}
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				}
			}
		}
		return instance;
	}
    /**
     * <pre>
     * 臾몄옄�뿴�뿉�꽌 HTML �깭洹몄뿉 ���븳 Encoding�쓣�븯�뿬 由ы꽩�븳�떎.
     *   �궗�슜�옄 �엯�젰媛믪쓣 HTML �긽�뿉 �엯�젰�맂 ��濡� �몴�떆�븯湲� �쐞�빐�꽌�뒗 htmlEncoding�쓣 �븯�뿬�빞�븳�떎.
     *   怨듬갚怨� �돱�씪�씤�뿉 ���븳 泥섎━源뚯� �룷�븿�븳�떎.
     * </pre>
     *
     * @param   source    臾몄옄�뿴
     * @param   ifEmpty   臾몄옄�뿴�씠 鍮덈Ц�옄�뿴�씪 寃쎌슦 ��泥댄븷 臾몄옄�뿴
     * @return  �씤肄붾뵫�맂 臾몄옄�뿴
     */
    public static String htmlEncodeWithBR(String source) {
        String s = htmlEncode(source);
        s = replace(s, " ", "&nbsp;");
        s = replace(s, "\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
        s = replace(s, "\r\n", "<br>");
        s = replace(s, "\n", "<br>");
        s = replace(s, "img&nbsp;", "img ");
        s = replace(s, "src=&quot;", "src=\"");
        s = replace(s, "&quot;>", "\">");

        return s;
    }
	
    /**
     * <pre>
     * 臾몄옄�뿴�뿉�꽌 HTML �깭洹몄뿉 ���븳 Encoding�쓣�븯�뿬 由ы꽩�븳�떎.
     *   �궗�슜�옄 �엯�젰媛믪쓣 HTML �긽�뿉 �엯�젰�맂 ��濡� �몴�떆�븯湲� �쐞�빐�꽌�뒗 htmlEncoding�쓣 �븯�뿬�빞�븳�떎.
     *   怨듬갚怨� �돱�씪�씤�뿉 ���븳 泥섎━源뚯� �룷�븿�븯�젮硫�(蹂몃Ц �궡�슜 �벑), htmlEncodingWithBR()�쓣 �궗�슜�븷 寃�
     * </pre>
     *
     * @param   source    臾몄옄�뿴
     * @param   ifEmpty   臾몄옄�뿴�씠 鍮덈Ц�옄�뿴�씪 寃쎌슦 ��泥댄븷 臾몄옄�뿴
     * @return  �씤肄붾뵫�맂 臾몄옄�뿴
     */
    public static String htmlEncode(String source) {
        if (source == null || source.length() == 0)
            return "";

        String s = source;
        //s = replace(s, "#",  "%23");
        //s = replace(s, "%",  "%25");
        s = replace(s, "&", "&amp;");
        s = replace(s, "'", "&#39;");
        s = replace(s, "\"", "&quot;");
        s = replace(s, "<", "&lt;");
        s = replace(s, ">", "&gt;");
        s = replace(s, "###&lt;", "<");
        s = replace(s, "&gt;###", ">");

        return s;
    }	
}
