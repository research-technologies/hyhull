# app/models/uketd_object.rb
# Fedora object for the uketd ETD content type
class UketdObject < ActiveFedora::Base
  include Hydra::ModelMethods
  include Hyhull::ModelMethods
  include Hyhull::ContentMetadataBehaviour
  include Hyhull::GenericParentBehaviour
  include Hyhull::ResourceWorkflowBehaviour
  include Hyhull::FullTextIndexableBehaviour
  include Hyhull::OaiHarvestableBehaviour
  include Hyhull::Validators 

  # Extra validations for the resource_state state changes
  UketdObject.state_machine :resource_state do   
    state :hidden do
      validates :resource_status, presence: true
    end

    state :deleted do
      validates :resource_status, presence: true
    end
  end

  # We only apply additional metadata on save when in proto queue...
  before_save :apply_additional_metadata, if: :resource_proto? 

  has_metadata name: "descMetadata", label: "MODS metadata", type: Datastream::ModsEtd
  has_metadata name: "rightsMetadata", label: "Rights metadata" , type: Hydra::Datastream::RightsMetadata

  # UKETD_DC Datastream - Utilises Disseminator on the Fedora instance
  has_metadata name: "UKETD_DC", label: "UKETD_DC metadata", autocreate: true, control_group: "E", 
                disseminator: "hull-sDef:uketdObject/getUKETDMetadata", versionable: false, :type => ActiveFedora::OmDatastream

  # Attributes to respective datastream
  #Unique fields
  has_attributes :title, :abstract, :date_issued, :date_valid, :rights, :ethos_identifier, :language_text, :language_code, :publisher , :qualification_level, :qualification_name, 
                   :dissertation_category, :type_of_resource, :genre, :mime_type, :digital_origin, :identifier, :primary_display_url, :raw_object_url, :extent, :record_creation_date, 
                     :record_change_date, :resource_status, datastream: :descMetadata, multiple: false
  # Non-unique fields
  # People
  has_attributes :person_name, :person_role_text, datastream: :descMetadata, multiple: true
  # Organisations
  has_attributes :organisation_name, :organisation_role_text, datastream: :descMetadata, multiple: true
  has_attributes :subject_topic, :grant_number, datastream: :descMetadata, multiple: true

  # Ensure that description is available (redirects to abstract)
  has_attributes :description, at: [:abstract], datastream: :descMetadata, multiple: false
 
  # Static Relator terms 
  delegate :person_role_terms, to: Datastream::ModsEtd, multiple: false
  delegate :organisation_role_terms, to: Datastream::ModsEtd, multiple: false

  # Standard validations for the object fields
  validates :title, presence: true
  validates :person_name, array: { :length => { :minimum => 5 } }
  validates :person_role_text, array: { :length => { :minimum => 3 } } 
  validates :subject_topic, array: { :length => { :minimum => 2 } }
  validates :language_code, presence: true
  validates :language_text, presence: true 
  validates :publisher, presence: true
  validates :qualification_level, presence: true
  validates :qualification_name, presence: true
  validates :date_issued, presence: true, format: { with: /^(\d{4}-\d{2}-\d{2}|\d{4}-\d{2}|\d{4})/ }

  def apply_additional_metadata
    #personal_creator_name

    names = []
    creators = self.descMetadata.creator_name

    creators.each do |creator|
      name_parts = creator.gsub(".", "").split(",").reverse.map{ |name| name.strip }
      names << name_parts.join(" ")
    end

    if date_issued.empty? 
      copyright_year = ""
    else
      copyright_year = Date.parse(to_long_date(date_issued)).strftime("%Y")
    end
    self.rights = Datastream::ModsEtd.all_rights_reserved_statement(names, copyright_year)
  end

  # Overide the attributes method to enable the calling of custom methods
  def attributes=(properties)
    super(properties)
    self.descMetadata.add_names(properties["person_name"], properties["person_role_text"], "person") unless properties["person_name"].nil? or properties["person_role_text"].nil?
    self.descMetadata.add_names(properties["organisation_name"], properties["organisation_role_text"], "organisation") unless properties["organisation_name"].nil? or properties["organisation_role_text"].nil? 
    self.descMetadata.add_subject_topic(properties["subject_topic"]) unless properties["subject_topic"].nil?
    self.descMetadata.add_grant_number(properties["grant_number"]) unless properties["grant_number"].nil?
  end
 
  # assert_content_model overidden to add UketdObject custom models
  def assert_content_model
    add_relationship(:has_model, "info:fedora/hydra-cModel:commonMetadata")
    super
  end

  # to_solr overridden to add object_type facet field to document
  def to_solr(solr_doc = {})
    super(solr_doc)
    solr_doc.merge!("object_type_sim" => "Thesis or dissertation")
    solr_doc
  end
 
 end

