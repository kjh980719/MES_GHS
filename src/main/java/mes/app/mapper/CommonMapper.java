package mes.app.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface CommonMapper {

    Map PLATFORM_INFO_S4_Str(int platfromCode);

    @Select("select * from file_info where file_key = #{fileId}")
    Map getFileInfo(String fileId);

    @Insert("insert into file_info(file_key, file_name, file_path, file_size) values(#{file_key}, #{file_name}, #{file_path}, #{file_size})")
    void insertFileInfo(@Param("file_key") String file_key, @Param("file_name") String file_name, @Param("file_path") String file_path, @Param("file_size") long file_size);

    void updateComContract(Map paramMap);

    void licenseContract(Map paramMap);

    void insContract(Map paramMap);

    void deleteContract(Map paramMap);

    void deleteLicense(Map paramMap);

    void deleteIns(Map paramMap);

}
