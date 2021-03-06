# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#hyhull Roles
#Clear existing roles in dev/test mode only.. 
unless Rails.env.production?
  Role.delete_all 
  RoleType.delete_all 
  Person.delete_all
  PropertyType.delete_all
  Property.delete_all
end

# Set role types - These are required for the Hyhull Application
# hyhull: hyhull application specific role types
# user: user role types generally 'staff/student/guest'

# department_ou/faculty_code
["hyhull", "user", "department_ou", "faculty_code"].each {|rt| RoleType.create(name: rt)}

# Seed the hyhull roles
# These are the required hyhull specific roles - See config/inintializers/hyhull.rb for the configuration of the roles
[{ name: HYHULL_USER_GROUPS[:content_access_team], description: "Content and Access Team"}, 
  { name: HYHULL_USER_GROUPS[:content_creator], description: "Content creator"},
  { name: HYHULL_USER_GROUPS[:yif_group], description: "YIF Group"},
  { name: HYHULL_USER_GROUPS[:administrator] , description: "Hyhull admininstrator" }
].each{ |r| Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("hyhull")) }

# Seed the user roles
# The standard list of user roles
[{ name: "staff", description: "University staff role"},
  { name:"student", description: "University student role"},  
  { name:"guest", description: "University guest role"}
].each{ |r| Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("user")) }

# # Seed staff role
# [{ name:"staff", description: "University staff role"}
# ].each{ |r| Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("staff")) }

# Seed the department roles
# We need to think about seeding the full list for production..
[{ name:"no_department", description: "No Department OU"} 
].each{ |r| Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("department_ou")) }

# Seed the faculty roles
# We need to think about seeding the full list for production..
[{ name:"no_faculty", description: "No Faculty code"} 
].each{ |r| Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("faculty_code")) }
  
# Seed the PropertyType table
[ { name: "EXAM-PAPER-DEPARTMENT", description: "Examination paper department"},
  { name: "EXAM-PAPER-LEVEL", description: "Examination paper level"},
  { name: "ETD-QUALIFICATION-LEVEL", description: "ETD qualification level"},
  { name: "ETD-QUALIFICATION-NAME", description: "ETD qualification name"},
  { name: "ETD-DISSERTATION-CATEGORY", description: "ETD dissertation category"},
  { name: "FEDORA-PID-NAMESPACE", description: "Fedora PID namespace"},
  { name: "JOURNAL-ARTICLE-AFFILIATION", description: "Journal Article Department Affiliation"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-ARTS", description: "Journal Article Department Affiliation Faculty Arts"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-SCI", description: "Journal Article Department Affiliation Faculty Sci"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-HEALTH", description: "Journal Article Department Affiliation Faculty Health"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-EDUCATION", description: "Journal Article Department Affiliation Faculty Education"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-BUSINESS-SCHOOL", description: "Journal Article Department Affiliation Faculty Business School"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-HYMS", description: "Journal Article Department Affiliation Faculty HYMS"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-FACE", description: "Journal Article Department Affiliation Faculty FACE"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-FOSE", description: "Journal Article Department Affiliation Faculty FOSE"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-FBLP", description: "Journal Article Department Affiliation Faculty FBLP"},
  { name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-INSTITUTES", description: "Journal Article Department Affiliation Faculty INSTITUTES"},
  { name: "JOURNAL-ARTICLE-REF-VERSION", description: "Journal Article REF version" }
].each { |p| PropertyType.create(name: p[:name], description: p[:description]) }

# Seed the REF exceptions table
[ 
  { 
    name: "REF-EXCEPTION-TECHNICAL", 
    description: "Journal Article REF Technical exception" 
  },
  { 
    name: "REF-EXCEPTION-DEPOSIT", 
    description: "Journal Article REF desposit exception"
  },
  { 
    name: "REF-EXCEPTION-ACCESS", 
    description: "Journal Article REF access exception" 
  } 
].each { |r| PropertyType.create(name: r[:name], description: r[:description]) }

# Seed some default/test values in the Property table
unless Rails.env.production? 
  # EXAM-PAPER-DEPARTMENT
  ["Accounting and Finance","Business School","Centre for Lifelong Learning","Centre for Mathematics","Centre for Neuroscience",
    "Community/Rehabilitation Studies","Department of Chemistry",
    "Department of Computer Science"].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "EXAM-PAPER-DEPARTMENT").first)}
  
  #EXAM-PAPER-LEVEL
  ["Level 4", "Level 5", "Level 6", "Level 7", "Level M", "Foundation level"].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "EXAM-PAPER-LEVEL").first)}

  #ETD-QUALIFICATION-LEVEL
  ["Doctoral", "Masters", "Undergraduate"].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "ETD-QUALIFICATION-LEVEL").first)}

  #ETD-QUALIFICATION-NAME
  ["PhD", "ClinPsyD", "MD", "PsyD", "MA" , "MEd", "MEng", "MPhil", "MRes",
    "MSc" , "MTheol", "EdD" , "DBA", "BA", "BSc"].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "ETD-QUALIFICATION-NAME").first)}

  #ETD-DISSERTATION-CATEGORY
  ["Blue", "Green", "Red"].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "ETD-DISSERTATION-CATEGORY").first)}

  #FEDORA-PID-NAMESPACE
  ["hull", "hull-archives"].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "FEDORA-PID-NAMESPACE").first)}

  #JOURNAL-ARTICLE-AFFILIATION
  ["Faculty of Science and Engineering", " Centre for Environmental and Marine Sciences", " Department of Chemistry", " Department of Computer Science", " Department of Geography", " Environment and Earth Sciences", " Department of Mathematics", " Department of Physics", " Department of Psychology", " Department of Sport, Health and Exercise Science", " Institute for Estuarine and Coastal Studies", " School of Biological, Biomedical and Environmental Sciences", " School of Engineering",
   "Faculty of Arts and Social Sciences", " Department of American Studies", " Department of English", " Department of History", " Law School", " Maritime Historical Studies Centre", " School of Arts and New Media", " School of Drama, Music and Screen", " School of Languages, Linguistics and Culture", " School of Politics, Philosophy and International Studies", " School of Social Sciences", " Wilberforce Institute for the study of Slavery and Emancipation"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION").first)}

  #JOURNAL-ARTICLE-AFFILIATION-FACULTY-ARTS
  ["Faculty of Arts and Social Sciences", " Department of American Studies", " Department of English", " Department of History", " Law School", " Maritime Historical Studies Centre", " School of Arts and New Media", " School of Drama, Music and Screen", " School of Languages, Linguistics and Culture", " School of Politics, Philosophy and International Studies", " School of Social Sciences", " Wilberforce Institute for the study of Slavery and Emancipation"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-ARTS").first)}

  #JOURNAL-ARTICLE-AFFILIATION-FACULTY-SCI
  ["Faculty of Science and Engineering", " Centre for Environmental and Marine Sciences", " Department of Chemistry", " Department of Computer Science", " Department of Geography", " Environment and Earth Sciences", " Department of Mathematics", " Department of Physics", " Department of Psychology", " Department of Sport, Health and Exercise Science", " Institute for Estuarine and Coastal Studies", " School of Biological, Biomedical and Environmental Sciences", " School of Engineering"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-SCI").first)}

  #JOURNAL-ARTICLE-AFFILIATION-FACULTY-EDUCATION
  ["Faculty of Education", "Centre for Educational Studies"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-EDUCATION").first)}

  #JOURNAL-ARTICLE-AFFILIATION-FACULTY-HEALTH
  ["Faculty of Health and Social Care"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-HEALTH").first)}

  #JOURNAL-ARTICLE-AFFILIATION-FACULTY-BUSINESS-SCHOOL
  ["Hull University Business School", " Logistics Institute"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-BUSINESS-SCHOOL").first)}

#JOURNAL-ARTICLE-AFFILIATION-FACULTY-HYMS
  ["Hull York Medical School"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-HYMS").first)}

#JOURNAL-ARTICLE-AFFILIATION-FACULTY-FACE
  [" School of Arts" "School of History, Languages and Cultures", "School of Social Sciences and Education"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-FACE").first)}

#JOURNAL-ARTICLE-AFFILIATION-FACULTY-FOSE
  ["School of Engineering and Computer Science", "School of Environmental Sciences", "School of Life Sciences", "School of Mathematical and Physical Sciences"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-FOSE").first)}

#JOURNAL-ARTICLE-AFFILIATION-FACULTY-FBLP
  [" Hull University Business School", "School of Law and Politics"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-FBLP").first)}

#JOURNAL-ARTICLE-AFFILIATION-FACULTY-INSTITUTES
  ["Institute for Cultures and Creative Industries", "Institute for Energy and the Environment", "Institute for Marine and Maritime Studies", "Logistics Institute","Wilberforce Institute"
  ].each { |n| Property.create(name: n, value: n, property_type: PropertyType.where(name: "JOURNAL-ARTICLE-AFFILIATION-FACULTY-INSTITUTES").first)}

  # REF-EXCEPTION-TECHNICAL
  [
    "Conference proceeding outside scope (non-ISSN)",
    "Depositer at different University which failed to comply with HEFCE policy",
    "Short-term technical failure of repository that prevented compliance",
    "External service provider failure prevented compliance"
  ].each { |n| Property.create(
      name: n, 
      value: n, 
      property_type: PropertyType.where(name: "REF-EXCEPTION-TECHNICAL").first
    )
  }

  # REF-EXCEPTION-DEPOSIT
  [
    "Depositer unable to use a repository at point of acceptance",
    "Delay in securing final peer-reviewed text",
    "Depositer not employed by UK HEI at time of submission",
    "Deposit or request to deposit would be unlawful",
    "Deposit would present a security risk",
    "Ouput published as Gold Open Access"
  ].each { |n| Property.create( 
      name: n, 
      value: n, 
      property_type: PropertyType.where(name: "REF-EXCEPTION-DEPOSIT").first 
    ) 
  }

  # REF-EXCEPTION-ACCESS
  [
    "Open access reproduction rights not granted",
    "Embargo period required exceeds maximum allowed, but publication is most appropriate",
    "Publication actively disallows open access, but is most appropriate"
  ].each { |n| Property.create(
      name: n,
      value: n,
      property_type: PropertyType.where(name: "REF-EXCEPTION-ACCESS").first
    )
  }

  # REF-VERSION
  [
    "AO", "SMUR", "AM", "P", "VoR", "CVoR", "EVoR", "NA"
  ].each { |n| Property.create(
      name: n,
      value: n,
      property_type: PropertyType.where(name: "JOURNAL-ARTICLE-REF-VERSION").first
    )
  }

end



# **************************** #
#  IMPORTANT - For Test        #
# **************************** #
#                              #
# These get loaded in the database, and important for running the Tests
# Also loaded in development mode for extra test roles/users. 
unless Rails.env.production?
  # For test lets seed some made up departments and faculities (these need to exist in the Roles DB to be picked up on user login)

  # Seed the dep roles
  [{ name:"IT", description: "IT Department"},
  { name:"LLI", description: "LLI Department"},  
  { name:"CompSci", description: "Computer Science"}
  ].each{ |r| Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("department_ou")) }

  # Seed the faculty roles
  [{ name:"123", description: "IT/LLI Faculty"},
  { name:"456", description: "Science and Engineering"} 
  ].each{ |r| Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("faculty_code")) }

  # Seed some 'people' into the Person model, in production the Person model is populated from the Portal Person DB
  # These accounts are for test purposes only...
   [{ username: 'admin1',  given_name: 'The', family_name: 'Admin', email_address: 'admin1@example.com', 
     user_type: 'staff', department_ou: 'IT', faculty_code: '123'},
     { username: 'contentaccessteam1',  given_name: 'content', family_name: 'team', email_address: 'contentAccessTeam1@example.com', 
     user_type: 'contentAccessTeam', department_ou: 'IT', faculty_code: '123'},
     { username: 'contentcreator1',  given_name: 'content', family_name: 'creator', email_address: 'contentCreator1@example.com', 
     user_type: 'staff', department_ou: 'IT', faculty_code: '123'},
     { username: 'staff1',  given_name: 'staff', family_name: 'user', email_address: 'staff1@example.com', 
     user_type: 'staff', department_ou: 'IT', faculty_code: '123'},
     { username: 'student1',  given_name: 'student', family_name: 'user', email_address: 'student1@example.com', 
     user_type: 'student', department_ou: 'CompSci', faculty_code: '456'},
     { username: 'archivist1',  given_name: 'archivist', family_name: 'user', email_address: 'archivist1@example.com', 
     user_type: 'archivist', department_ou: 'LLI', faculty_code: '123'},
     { username: 'bigwig',  given_name: 'bigwig', family_name: 'user', email_address: 'bigwig@example.com', 
     user_type: 'staff', department_ou: 'LLI', faculty_code: '123'}
     ].each do |p|
         person = Person.new
         person.username = p[:username]
         person.given_name = p[:given_name]
         person.family_name = p[:family_name]
         person.email_address = p[:email_address]
         person.user_type = p[:user_type]
         person.department_ou = p[:department_ou]
         person.faculty_code = p[:faculty_code]
         person.save
  end

end

# **************************** #
#  IMPORTANT - For Development #
# **************************** #
#                              #
# We will probably want to add entries to People and Roles(Departments/Faculties) that work with our development instance of CAS, i.e. users that can authenticate 
# I.e if we authenticate with the user 'test_admin_1' who has a department of test and faculty code of '001' we will add...
# ... a Person to the people table with a username of 'test_admin_1', and faculty_code of '001' and department_ou of 'test_dep'
# We would also need to add faculty and department to the Roles table for them to be recognised on login. See commented example below...
if Rails.env.development?

 # ******************************************************************************************
 # NOTE: The following is example of a Person you can add to People for development purposes

 # [{ username: 'test_admin_1',  given_name: 'Test', family_name: 'Admin', email_address: 'test_admin_1@example.com', 
 #     user_type: 'staff', department_ou: 'test_dep', faculty_code: '001'}].each do |p|
 #         person = Person.new
 #         person.username = p[:username]
 #         person.given_name = p[:given_name]
 #         person.family_name = p[:family_name]
 #         person.email_address = p[:email_address]
 #         person.user_type = p[:user_type]
 #         person.department_ou = p[:department_ou]
 #         person.faculty_code = p[:faculty_code]
 #         person.save
 #  end

 #  # NOTE: The following is example of the corresponding Department roles you will need to add to match the above Person
 #  [{ name:"test_dep", description: "Test Department"}].each do |r| 
 #    Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("department_ou")) 
 #  end


 #  # NOTE: The following is example of the corresponding Faculty roles you will need to add to match the above Person
 #  [{ name:"001", description: "Test Faculty"}].each do |r|
 #    Role.create(name: r[:name], description: r[:description], role_type: RoleType.find_or_initialize_by_name("faculty_code"))
 #  end

end